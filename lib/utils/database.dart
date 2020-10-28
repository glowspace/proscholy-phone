import 'dart:math';

import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zpevnik/models/entities/author.dart';
import 'package:zpevnik/models/entities/song.dart';
import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/models/entities/songbook.dart';
import 'package:zpevnik/models/entities/tag.dart';
import 'package:zpevnik/utils/adapter.dart';
import 'package:zpevnik/utils/beans.dart';

class Database {
  CustomAdapter _adapter;

  Database._();

  static final Database shared = Database._();

  Future<void> init() async {
    _adapter = new CustomAdapter(join(await getDatabasesPath(), 'zpevnik.db'));

    await _adapter.connect();

    // for (Bean bean in [
    //   SongLyricBean(_adapter),
    //   SongBean(_adapter),
    //   SongbookBean(_adapter),
    //   AuthorBean(_adapter),
    //   ExternalBean(_adapter),
    //   TagBean(_adapter),
    //   PlaylistBean(_adapter),
    //   SongbookRecordBean(_adapter),
    //   SongLyricAuthorBean(_adapter),
    //   SongLyricTagBean(_adapter),
    //   SongLyricPlaylistBean(_adapter),
    //   AuthorExternalBean(_adapter)
    // ]) bean.drop();

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

  Future<void> saveAuthors(List<Author> authors) => AuthorBean(_adapter)
      .insertMany(authors)
      .catchError((error) => print(error));

  Future<void> saveTags(List<TagEntity> tags) =>
      TagBean(_adapter).insertMany(tags).catchError((error) => print(error));

  Future<void> saveSongbooks(List<Songbook> songbooks) => SongbookBean(_adapter)
      .insertMany(songbooks)
      .catchError((error) => print(error));

  Future<void> saveSongs(List<Song> songs) async {
    for (final batch in _splitInBatches(songs))
      await SongBean(_adapter)
          .insertMany(batch)
          .catchError((error) => print(error));
  }

  Future<void> saveSongLyrics(List<SongLyric> songLyrics) async {
    for (final batch in _splitInBatches(songLyrics))
      await SongLyricBean(_adapter)
          .insertMany(batch, cascade: true)
          .catchError((error) => print(error));
  }

  Future<void> saveSongLyric(SongLyric songLyric) =>
      SongLyricBean(_adapter).insert(songLyric, cascade: true);

  Future<List<TagEntity>> get tags => TagBean(_adapter).getAll();

  Future<List<Songbook>> get songbooks async {
    final bean = SongbookBean(_adapter);

    return bean
        .findWhere(bean.isPrivate.ne(true))
        .catchError((error) => print(error));
  }

  Future<List<SongLyric>> get songLyrics async {
    final bean = SongLyricBean(_adapter);
    final songLyrics = await bean
        .findWhere(bean.lyrics.isNot(null))
        .catchError((error) => print(error));

    for (final batch in _splitInBatches(songLyrics))
      bean.preloadAll(batch, cascade: true).catchError((error) => print(error));

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
