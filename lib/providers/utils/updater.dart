import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zpevnik/models/author.dart';
import 'package:zpevnik/models/song.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/utils/client.dart';

final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

const _lastUpdateKey = 'last_update';
const _initialLastUpdate = '2022-07-05 00:00:00';

const _updatePeriod = Duration(hours: 1);

abstract class UpdaterState {}

class UpdaterStateLoading extends UpdaterState {}

class UpdaterStateUpdating extends UpdaterState {
  final int current;
  final int count;

  UpdaterStateUpdating(this.current, this.count);

  UpdaterState get next => current + 1 == count ? UpdaterStateDone(count) : UpdaterStateUpdating(current + 1, count);

  @override
  String toString() => '$current/$count';
}

class UpdaterStateIdle extends UpdaterState {}

class UpdaterStateDone extends UpdaterState {
  final int updatedCount;

  UpdaterStateDone(this.updatedCount);
}

class UpdaterStateError extends UpdaterState {
  final String error;

  UpdaterStateError(this.error);
}

class Updater {
  final Store store;

  Updater(this.store);

  final ValueNotifier<UpdaterState> state = ValueNotifier(UpdaterStateIdle());
  int updatingSongLyricsCount = 0;

  bool get isUpdating => state.value is! UpdaterStateIdle;

  Future<void> loadInitial() async {
    // TODO: remove json file after loading
    final json = jsonDecode(await rootBundle.loadString('assets/data.json'));

    SharedPreferences.getInstance().then((prefs) => prefs.remove(_lastUpdateKey));

    await _parse(json['data']);
  }

  Future<void> update() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdateString = prefs.getString(_lastUpdateKey) ?? _initialLastUpdate;
    final lastUpdate = _dateFormat.parseUtc(lastUpdateString);

    final now = DateTime.now().toUtc();

    if (now.isBefore(lastUpdate.add(_updatePeriod))) return;

    state.value = UpdaterStateLoading();

    final client = Client();

    final data = await client.getData();
    final List<int> songLyricIds = (data['song_lyrics'] as List<dynamic>)
        .where((json) => _dateFormat.parse(json['updated_at']).isAfter(lastUpdate))
        .map((json) => int.parse(json['id']))
        .cast<int>()
        .toList();

    if (songLyricIds.isEmpty) {
      state.value = UpdaterStateIdle();

      client.dispose();

      prefs.setString(_lastUpdateKey, _dateFormat.format(now));

      return;
    }

    state.value = UpdaterStateUpdating(0, songLyricIds.length);

    final List<Future> futures = [];

    for (final songLyricId in songLyricIds) {
      futures.add(
          client.getSongLyric(songLyricId).then((json) => state.value = (state.value as UpdaterStateUpdating).next));
    }

    try {
      await Future.wait(futures);
    } catch (error) {
      state.value = UpdaterStateError('$error');
    }

    client.dispose();

    prefs.setString(_lastUpdateKey, _dateFormat.format(now));
  }

  Future<void> _parse(Map<String, dynamic> json) async {
    final authors = Author.fromMapList(json);
    final songs = Song.fromMapList(json);
    final songbooks = Songbook.fromMapList(json);
    final tags = Tag.fromMapList(json);

    await Future.wait([
      store.runInTransactionAsync<List<int>, List<Author>>(
        TxMode.write,
        (store, params) => store.box<Author>().putMany(params),
        authors,
      ),
      store.runInTransactionAsync<List<int>, List<Song>>(
        TxMode.write,
        (store, params) => store.box<Song>().putMany(params),
        songs,
      ),
      store.runInTransactionAsync<List<int>, List<Songbook>>(
        TxMode.write,
        (store, params) => store.box<Songbook>().putMany(params),
        songbooks,
      ),
      store.runInTransactionAsync<List<int>, List<Tag>>(
        TxMode.write,
        (store, params) => store.box<Tag>().putMany(params),
        tags,
      ),
    ]);

    final songLyrics = await store.runInTransactionAsync<List<SongLyric>, Map<String, dynamic>>(
        TxMode.read, (store, params) => SongLyric.fromMapList(params, store), json);

    await store.runInTransactionAsync<List<int>, List<SongLyric>>(
      TxMode.write,
      (store, params) => store.box<SongLyric>().putMany(params),
      songLyrics,
    );
  }
}
