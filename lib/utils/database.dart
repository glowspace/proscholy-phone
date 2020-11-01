import 'dart:math';

import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zpevnik/models/entities/author.dart';
import 'package:zpevnik/models/entities/song.dart';
import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/models/entities/songbook.dart';
import 'package:zpevnik/models/entities/songbook_record.dart';
import 'package:zpevnik/models/entities/tag.dart';
import 'package:zpevnik/utils/beans.dart';

class Database {
  SqfliteAdapter _adapter;

  Database._();

  static final Database shared = Database._();

  Future<void> init() async {
    _adapter = new SqfliteAdapter(join(await getDatabasesPath(), 'zpevnik.db'));

    await _adapter.connect();

    await Future.wait([
      SongLyricBean(_adapter).createTable(ifNotExists: true),
      SongBean(_adapter).createTable(ifNotExists: true),
      SongbookBean(_adapter).createTable(ifNotExists: true),
      AuthorBean(_adapter).createTable(ifNotExists: true),
      ExternalBean(_adapter).createTable(ifNotExists: true),
      TagBean(_adapter).createTable(ifNotExists: true),
      PlaylistBean(_adapter).createTable(ifNotExists: true),
      SongbookRecordBean(_adapter).createTable(ifNotExists: true),
      SongLyricAuthorBean(_adapter).createTable(ifNotExists: true),
      SongLyricTagBean(_adapter).createTable(ifNotExists: true),
      SongLyricPlaylistBean(_adapter).createTable(ifNotExists: true),
      AuthorExternalBean(_adapter).createTable(ifNotExists: true),
    ]);
  }

  Future<void> saveAuthors(List<Author> authors) async {
    for (final batch in _splitInBatches(authors))
      await AuthorBean(_adapter).upsertMany(batch).catchError((error) => print(error));
  }

  Future<void> saveTags(List<TagEntity> tags) => TagBean(_adapter).upsertMany(tags).catchError((error) => print(error));

  Future<void> saveSongbooks(List<SongbookEntity> songbooks) =>
      SongbookBean(_adapter).upsertMany(songbooks).catchError((error) => print(error));

  Future<void> saveSongs(List<Song> songs) async {
    for (final batch in _splitInBatches(songs))
      await SongBean(_adapter).upsertMany(batch).catchError((error) => print(error));
  }

  Future<void> saveSongLyrics(List<SongLyricEntity> songLyrics) async {
    for (final batch in _splitInBatches(songLyrics))
      await SongLyricBean(_adapter).upsertMany(batch).catchError((error) => print(error));
  }

  Future<void> saveSongbookRecords(List<SongbookRecord> songbookRecords) =>
      SongbookRecordBean(_adapter).upsertMany(songbookRecords).catchError((error) => print(error));

  Future<void> saveSongLyricTags(List<SongLyricTag> songLyricTags) =>
      SongLyricTagBean(_adapter).upsertMany(songLyricTags).catchError((error) => print(error));

  Future<void> updateSongbook(SongbookEntity songbook, Set<String> only) =>
      SongbookBean(_adapter).update(songbook, only: only).catchError((error) => print(error));

  Future<void> updateSongLyric(SongLyricEntity songLyric, Set<String> only) =>
      SongLyricBean(_adapter).update(songLyric, only: only).catchError((error) => print(error));

  Future<List<TagEntity>> get tags => TagBean(_adapter).getAll();

  Future<List<SongbookEntity>> get songbooks {
    final bean = SongbookBean(_adapter);

    return bean.findWhere(bean.isPrivate.ne(true)).catchError((error) => print(error));
  }

  Future<List<SongLyricEntity>> get songLyrics async {
    final bean = SongLyricBean(_adapter);
    final songLyrics = await bean.findWhere(bean.lyrics.isNot(null)).catchError((error) => print(error));

    // custom preloading, normal preload is too slow
    Map<int, List<SongbookRecord>> songbookRecords = {};
    Map<int, List<TagEntity>> songLyricTags = {};

    for (final songbookRecord in await SongbookRecordBean(_adapter).getAll()) {
      if (!songbookRecords.containsKey(songbookRecord.songLyricId)) songbookRecords[songbookRecord.songLyricId] = [];

      songbookRecords[songbookRecord.songLyricId].add(songbookRecord);
    }

    for (final songLyricTag in await SongLyricTagBean(_adapter).getAll()) {
      if (!songLyricTags.containsKey(songLyricTag.songLyricId)) songLyricTags[songLyricTag.songLyricId] = [];

      songLyricTags[songLyricTag.songLyricId].add(TagEntity(id: songLyricTag.tagId));
    }

    for (SongLyricEntity songLyric in songLyrics) {
      songLyric.songbookRecords = songbookRecords[songLyric.id] ?? [];
      songLyric.tags = songLyricTags[songLyric.id] ?? [];
    }

    return songLyrics;
  }

  List<List<T>> _splitInBatches<T>(List<T> list) {
    List<List<T>> batches = [];

    final batchSize = 500;
    int index = 0;
    while (index < list.length) {
      batches.add(list.sublist(index, min(index + batchSize, list.length)));
      index += batchSize;
    }

    return batches;
  }
}
