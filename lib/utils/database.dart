import 'dart:math';

import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zpevnik/models/author.dart';
import 'package:zpevnik/models/song.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/models/tag.dart';
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

    // await Future.wait([
    //   SongLyricBean(_adapter).createTable(),
    //   SongBean(_adapter).createTable(),
    //   SongbookBean(_adapter).createTable(),
    //   AuthorBean(_adapter).createTable(),
    //   ExternalBean(_adapter).createTable(),
    //   TagBean(_adapter).createTable(),
    //   PlaylistBean(_adapter).createTable(),
    //   SongbookRecordBean(_adapter).createTable(),
    //   SongLyricAuthorBean(_adapter).createTable(),
    //   SongLyricTagBean(_adapter).createTable(),
    //   SongLyricPlaylistBean(_adapter).createTable(),
    //   AuthorExternalBean(_adapter).createTable(),
    // ]);
  }

  Future<void> saveAuthors(List<Author> authors) => AuthorBean(_adapter)
      .insertMany(authors)
      .catchError((error) => print(error));

  Future<void> saveTags(List<Tag> tags) =>
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

  Future<List<Tag>> get tags => TagBean(_adapter).getAll();

  Future<List<SongLyric>> get songLyrics async {
    final bean = SongLyricBean(_adapter);
    final songLyrics = await bean.getAll().catchError((error) => print(error));

    for (final batch in _splitInBatches(songLyrics))
      await bean
          .preloadAll(batch, cascade: true)
          .catchError((error) => print(error));

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
