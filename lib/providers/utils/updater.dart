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
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/utils/client.dart';

final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

const _lastUpdateKey = 'last_update';
const _initialLastUpdate = '2022-07-26 13:29:00';

const _updatePeriod = Duration(hours: 1);

abstract class UpdaterState {}

class UpdaterStateUpdating extends UpdaterState {}

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

  Future<void> loadInitial() async {
    // TODO: remove json file after loading
    final json = jsonDecode(await rootBundle.loadString('assets/data.json'));

    SharedPreferences.getInstance().then((prefs) => prefs.remove(_lastUpdateKey));

    await _parse(json['data'], isSongLyricsFull: true);
  }

  Future<List<SongLyric>> update(DataProvider dataProvider) async {
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

    state.value = UpdaterStateUpdating();

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

      if (!existingSongLyricsIds.contains(id)) songLyricsIds.add(id);

      existingSongLyricsIds.remove(id);
    }

    // remove song lyrics that were removed on server
    box.removeMany(existingSongLyricsIds.toList());

    try {
      final songLyrics = SongLyric.fromMapList(await client.getSongLyrics(lastUpdate), store);

      for (final songLyric in songLyrics) {
        songLyricsIds.remove(songLyric.id);
      }

      // fetch missing song lyrics asynchronously
      final List<Future<SongLyric>> futures = [];

      for (final songLyricId in songLyricsIds) {
        futures.add(client.getSongLyric(songLyricId).then((json) => SongLyric.fromJson(json, store)));
      }

      songLyrics.addAll(await Future.wait(futures));

      // need to remove relations, because otherwise objectbox will just add new relations and keep old ones
      store.runInTransaction(TxMode.write, () {
        for (final songLyric in songLyrics) {
          final existingSongLyric = dataProvider.getSongLyricById(songLyric.id);

          if (existingSongLyric != null) {
            final authors = existingSongLyric.authors;
            final externals = existingSongLyric.externals;
            final songbookRecords = existingSongLyric.songbookRecords;
            final tags = existingSongLyric.tags;

            authors.clear();
            externals.clear();
            songbookRecords.clear();
            tags.clear();

            authors.applyToDb();
            externals.applyToDb();
            songbookRecords.applyToDb();
            tags.applyToDb();
          }
        }
      });

      box.putMany(songLyrics);

      if (songLyrics.isNotEmpty) {
        state.value = UpdaterStateDone(songLyrics.length);
      } else {
        state.value = UpdaterStateIdle();
      }

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

    final query = store.box<Songbook>().query(Songbook_.isPinned.equals(true)).build();
    final pinnedSongbooks = query.property(Songbook_.id).find().toSet();

    for (final songbook in songbooks) {
      songbook.isPinned = pinnedSongbooks.contains(songbook.id);
    }

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
