import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zpevnik/models/author.dart';
import 'package:zpevnik/models/news_item.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/song.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/utils/client.dart';

final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

const _lastUpdateKey = 'last_update';
const _initialLastUpdate = '2022-07-05 00:00:00';

const _updatePeriod = Duration(hours: 1);

const updateAnimationDuration = Duration(milliseconds: 1200);

abstract class UpdaterState {}

class UpdaterStateLoading extends UpdaterState {}

class UpdaterStateUpdating extends UpdaterState {
  final int current;
  final int count;

  UpdaterStateUpdating(this.current, this.count);

  UpdaterState get next => UpdaterStateUpdating(current + 1, count);

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

    await _parse(json['data'], isSongLyricsFull: true);
  }

  Future<List<SongLyric>> update() async {
    final client = Client();

    try {
      final newsItems = await client.getNews().then((json) => NewsItem.fromMapList(json));
      store.box<NewsItem>().putMany(newsItems);
    } on SocketException {
      client.dispose();

      return [];
    }

    // check if update should happen
    final prefs = await SharedPreferences.getInstance();
    final lastUpdateString = prefs.getString(_lastUpdateKey) ?? _initialLastUpdate;
    final lastUpdate = _dateFormat.parseUtc(lastUpdateString);

    final now = DateTime.now().toUtc();

    if (now.isBefore(lastUpdate.add(_updatePeriod))) {
      client.dispose();

      return [];
    }

    state.value = UpdaterStateLoading();

    // load updated data from server
    final data = await client.getData();

    await _parse(data);

    // query existing song lyrics to check song lyrics that are missing in local db or that were removed on server
    final box = store.box<SongLyric>();
    final query = box.query().build();
    final existingSongLyricsIds = query.property(SongLyric_.id).find().toSet();
    query.close();

    final List<int> songLyricsIds = [];

    for (final songLyric in data['song_lyrics']) {
      final id = int.parse(songLyric['id']);

      if (!existingSongLyricsIds.contains(id) || _dateFormat.parse(songLyric['updated_at']).isAfter(lastUpdate)) {
        songLyricsIds.add(id);
      }

      existingSongLyricsIds.remove(id);
    }

    // remove song lyrics that were removed on server
    box.removeMany(existingSongLyricsIds.toList());

    if (songLyricsIds.isEmpty) {
      state.value = UpdaterStateIdle();

      client.dispose();

      prefs.setString(_lastUpdateKey, _dateFormat.format(now));

      return [];
    }

    state.value = UpdaterStateUpdating(0, songLyricsIds.length);

    // fetch updated song lyrics asynchronously
    final List<Future<SongLyric>> futures = [];

    for (final songLyricId in songLyricsIds) {
      futures.add(client.getSongLyric(songLyricId).then((json) {
        state.value = (state.value as UpdaterStateUpdating).next;

        return SongLyric.fromJson(json, store);
      }));
    }

    try {
      final songLyrics = await Future.wait(futures);

      await Future.delayed(updateAnimationDuration + const Duration(milliseconds: 100));

      state.value = UpdaterStateDone(songLyrics.length);

      box.putMany(songLyrics);

      prefs.setString(_lastUpdateKey, _dateFormat.format(now));

      return songLyrics;
    } catch (error) {
      state.value = UpdaterStateError('$error');
    } finally {
      client.dispose();
    }

    return [];
  }

  Future<void> _parse(Map<String, dynamic> json, {bool isSongLyricsFull = false}) async {
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

    if (isSongLyricsFull) {
      final songLyrics = await store.runInTransactionAsync<List<SongLyric>, Map<String, dynamic>>(
          TxMode.read, (store, params) => SongLyric.fromMapList(params, store), json);

      await store.runInTransactionAsync<List<int>, List<SongLyric>>(
        TxMode.write,
        (store, params) => store.box<SongLyric>().putMany(params),
        songLyrics,
      );
    }
  }
}
