import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zpevnik/models/author.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/models/news_item.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/song.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/models/utils.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/utils/client.dart';

final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

const _lastUpdateKey = 'last_update';
const _initialLastUpdate = '2023-06-10 10:00:00';

const _updatePeriod = Duration(hours: 1);

class Updater {
  final Store store;
  final SharedPreferences prefs;

  Updater(this.store, this.prefs);

  int updatingSongLyricsCount = 0;

  Future<void> loadInitial() async {
    // TODO: remove json file after loading
    // This is not possible right now
    final json = jsonDecode(await rootBundle.loadString('assets/data.json'));

    SharedPreferences.getInstance().then((prefs) => prefs.remove(_lastUpdateKey));

    await _parse(json['data'], isSongLyricsFull: true);
  }

  Future<List<SongLyric>> update(DataProvider dataProvider) async {
    final client = Client();

    try {
      final newsItems =
          await client.getNews().then((json) => readJsonList(json[NewsItem.fieldKey], mapper: NewsItem.fromJson));
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
      final json = await client.getSongLyrics(lastUpdate);
      final songLyrics = readJsonList(json[SongLyric.fieldKey], mapper: SongLyric.fromJson);

      for (final songLyric in songLyrics) {
        songLyricsIds.remove(songLyric.id);
      }

      // fetch missing song lyrics asynchronously
      final List<Future<SongLyric>> futures = [];

      for (final songLyricId in songLyricsIds) {
        futures.add(client.getSongLyric(songLyricId).then((json) => SongLyric.fromJson(json)));
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

      prefs.setString(_lastUpdateKey, _dateFormat.format(now));

      return songLyrics;
    } catch (error) {
      rethrow;
    } finally {
      client.dispose();
    }
  }

  Future<void> _parse(Map<String, dynamic> json, {bool isSongLyricsFull = false}) async {
    final authors = readJsonList(json[Author.fieldKey], mapper: Author.fromJson);
    final songs = readJsonList(json[Song.fieldKey], mapper: Song.fromJson);
    final songbooks = readJsonList(json[Songbook.fieldKey], mapper: Songbook.fromJson);
    final tags = readJsonList(json[Tag.fieldKey], mapper: Tag.fromJson);

    // final query = store.box<Songbook>().query(Songbook_.isPinned.equals(true)).build();
    // final pinnedSongbooks = query.property(Songbook_.id).find().toSet();

    // for (final songbook in songbooks) {
    //   songbook.isPinned = pinnedSongbooks.contains(songbook.id);
    // }

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
      final songLyrics = readJsonList(json[SongLyric.fieldKey], mapper: SongLyric.fromJson);

      await store.box<External>().putManyAsync(songLyrics.firstWhere((element) => element.id == 149).externals);

      await store.runInTransactionAsync<List<int>, List<SongLyric>>(
        TxMode.write,
        (store, params) => store.box<SongLyric>().putMany(params),
        songLyrics,
      );
    }
  }
}
