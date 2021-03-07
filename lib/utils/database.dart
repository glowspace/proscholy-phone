import 'dart:math';

import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zpevnik/models/entities/author.dart';
import 'package:zpevnik/models/entities/entity.dart';
import 'package:zpevnik/models/entities/external.dart';
import 'package:zpevnik/models/entities/playlist.dart';
import 'package:zpevnik/models/entities/song.dart';
import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/models/entities/songbook.dart';
import 'package:zpevnik/models/entities/songbook_record.dart';
import 'package:zpevnik/models/entities/tag.dart';
import 'package:zpevnik/utils/beans.dart';

final _undesiredPartsRE = RegExp(r'(\d.|\[[^\]]+\])');

class Database {
  SqfliteAdapter _adapter;

  Database._();

  static final Database shared = Database._();

  Future<void> init(int oldVersion) async {
    _adapter = SqfliteAdapter(join(await getDatabasesPath(), 'zpevnik.db'));

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
    ]).catchError((error) => print(error));

    await migrate(oldVersion);
  }

  Future<void> migrate(int oldVersion) async {
    if (oldVersion == 0) {
      final songLyricBean = SongLyricBean(_adapter);
      await _adapter
          .alter(Alter(songLyricBean.tableName)
              .addString(songLyricBean.secondaryName1.name, isNullable: true, length: 100))
          .catchError((error) => print(error));
      await _adapter
          .alter(Alter(songLyricBean.tableName)
              .addString(songLyricBean.secondaryName2.name, isNullable: true, length: 100))
          .catchError((error) => print(error));
    }
    if (oldVersion < 3) {
      await _adapter.connection
          .rawQuery(
              'CREATE VIRTUAL TABLE IF NOT EXISTS song_lyrics_search USING FTS4(id, name, secondary_name1, secondary_name2, lyrics, numbers, numbers2, tokenize=unicode61);')
          .catchError((error) => print(error));
    }
  }

  Future<void> saveAuthors(List<AuthorEntity> authors) => _insertOrUpdateMany(authors, AuthorBean(_adapter));

  Future<void> saveTags(List<TagEntity> tags) => _insertOrUpdateMany(tags, TagBean(_adapter));

  Future<void> saveSongbooks(List<SongbookEntity> songbooks) => _insertOrUpdateMany(songbooks, SongbookBean(_adapter),
      only: ['id', 'name', 'shortcut', 'color', 'color_text', 'is_private'].toSet());

  Future<void> saveSongs(List<SongEntity> songs) => _insertOrUpdateMany(songs, SongBean(_adapter));

  Future<void> saveSongLyrics(List<SongLyricEntity> songLyrics) =>
      _insertOrUpdateMany(songLyrics, SongLyricBean(_adapter),
          only: [
            'id',
            'name',
            'secondary_name1',
            'secondary_name2',
            'lyrics',
            'language',
            'type',
            'lilypond',
            'song_id'
          ].toSet());

  Future<void> saveExternals(List<ExternalEntity> externals) => _insertOrUpdateMany(externals, ExternalBean(_adapter));

  Future<void> saveSongbookRecords(List<SongbookRecord> songbookRecords) =>
      SongbookRecordBean(_adapter).upsertMany(songbookRecords).catchError((error) => print(error));

  Future<void> saveSongLyricTags(List<SongLyricTag> songLyricTags) =>
      SongLyricTagBean(_adapter).upsertMany(songLyricTags).catchError((error) => print(error));

  Future<void> saveSongLyricAuthors(List<SongLyricAuthor> songLyricAuthors) =>
      SongLyricAuthorBean(_adapter).upsertMany(songLyricAuthors).catchError((error) => print(error));

  Future<void> savePlaylist(PlaylistEntity playlist) {
    PlaylistBean(_adapter).insert(playlist).catchError((error) => print(error));

    return SongLyricPlaylistBean(_adapter)
        .insertMany(playlist.songLyrics
            .map((songLyric) => SongLyricPlaylist()
              ..playlistId = playlist.id
              ..songLyricId = songLyric.id)
            .toList())
        .catchError((error) => print(error));
  }

  Future<void> removeOutdatedAuthors(List<int> ids) => _removeOutdated(ids, AuthorBean(_adapter));

  Future<void> removeOutdatedTags(List<int> ids) => _removeOutdated(ids, TagBean(_adapter));

  Future<void> removeOutdatedSongbooks(List<int> ids) => _removeOutdated(ids, SongbookBean(_adapter));

  Future<void> removeOutdatedSongs(List<int> ids) => _removeOutdated(ids, SongBean(_adapter));

  Future<void> removeOutdatedSongLyrics(List<int> ids) => _removeOutdated(ids, SongLyricBean(_adapter));

  Future<void> removeOutdatedExternals(List<int> ids) => _removeOutdated(ids, ExternalBean(_adapter));

  Future<void> updateSongLyricsSearchTable(List<SongLyricEntity> songLyrics, List<SongbookEntity> songbooks) async {
    final existing = {};

    for (final entity in await _adapter.connection.query(SongLyricBean(_adapter).tableName, columns: ['id']))
      existing[entity['id']] = true;

    List<SongLyricEntity> inserts = [];
    List<SongLyricEntity> updates = [];

    for (final entity in songLyrics) {
      if (existing.containsKey(entity.id))
        updates.add(entity);
      else
        inserts.add(entity);
    }

    Map<int, SongbookEntity> songbooksMap = {};
    Map<int, List<String>> records = {};
    Map<int, List<String>> records2 = {};

    for (final songbook in songbooks) songbooksMap[songbook.id] = songbook;

    for (final record in await SongbookRecordBean(_adapter).getAll()) {
      if (!records.containsKey(record.songLyricId)) records[record.songLyricId] = [];
      if (!records2.containsKey(record.songLyricId)) records2[record.songLyricId] = [];

      if (songbooksMap.containsKey(record.songbookId)) {
        records[record.songLyricId].add('${songbooksMap[record.songbookId].shortcut}${record.number}');
        records2[record.songLyricId].add(record.number);
      }
    }

    for (final batch in _splitInBatches(updates)) {
      final List<List<SetColumn>> data = [];
      final List<Expression> where = [];

      for (var i = 0; i < batch.length; ++i) {
        var model = batch[i];

        List<SetColumn> columns = SongLyricBean(_adapter)
            .toSetColumns(model, only: ['id', 'name', 'secondary_name1', 'secondary_name2'].toSet())
            .toList();

        columns.add(StrField('lyrics').set(model.lyrics.replaceAll(_undesiredPartsRE, '')));
        columns.add(StrField('numbers').set(records[model.id].toString()));
        columns.add(StrField('numbers2').set(records2[model.id].toString()));

        data.add(columns);
        where.add(IntField('id').eq(model.id));
      }
      final update = Sql.updateMany('song_lyrics_search').addAll(data, where);
      await _adapter.updateMany(update).catchError((error) => print(error));
    }

    for (final batch in _splitInBatches(inserts)) {
      final List<List<SetColumn>> data = [];
      for (var i = 0; i < batch.length; ++i) {
        var model = batch[i];

        List<SetColumn> columns = SongLyricBean(_adapter)
            .toSetColumns(model, only: ['id', 'name', 'secondary_name1', 'secondary_name2'].toSet())
            .toList();

        columns.add(StrField('lyrics').set(model.lyrics.replaceAll(_undesiredPartsRE, '')));
        columns.add(StrField('numbers').set(records[model.id].toString()));
        columns.add(StrField('numbers2').set(records2[model.id].toString()));

        data.add(columns);
      }
      final insert = Sql.insertMany('song_lyrics_search').addAll(data);
      await _adapter.insertMany(insert).catchError((error) => print(error));
    }
  }

  Future<void> updateSongbook(SongbookEntity songbook, Set<String> only) =>
      SongbookBean(_adapter).update(songbook, only: only).catchError((error) => print(error));

  Future<void> updateSongLyric(SongLyricEntity songLyric, Set<String> only) =>
      SongLyricBean(_adapter).update(songLyric, only: only).catchError((error) => print(error));

  Future<void> updatePlaylist(PlaylistEntity playlist, Set<String> only) =>
      PlaylistBean(_adapter).update(playlist, only: only).catchError((error) => print(error));

  Future<void> addPlaylistSongLyrics(PlaylistEntity playlist, List<SongLyricEntity> songLyrics) =>
      SongLyricPlaylistBean(_adapter).insertMany(songLyrics
          .map((songLyric) => SongLyricPlaylist()
            ..playlistId = playlist.id
            ..songLyricId = songLyric.id)
          .toList());

  Future<Map<int, SongEntity>> get songs async {
    Map<int, SongEntity> songs = {};
    for (final song in await SongBean(_adapter).getAll()) songs[song.id] = song;

    return songs;
  }

  Future<List<TagEntity>> get tags => TagBean(_adapter).getAll();

  Future<List<SongbookEntity>> get songbooks {
    final bean = SongbookBean(_adapter);

    return bean.findWhere(bean.isPrivate.ne(true)).catchError((error) => print(error));
  }

  Future<List<SongLyricEntity>> get songLyrics async {
    final bean = SongLyricBean(_adapter);
    final songLyrics = await bean.findWhere(bean.lyrics.isNot(null)).catchError((error) => print(error));

    // custom preloading, normal preload is too slow
    Map<int, SongbookEntity> _songbooks = {};
    Map<int, List<SongbookRecord>> songbookRecords = {};
    Map<int, List<TagEntity>> songLyricTags = {};
    Map<int, AuthorEntity> authors = {};
    Map<int, List<AuthorEntity>> songLyricAuthors = {};
    Map<int, List<ExternalEntity>> externals = {};
    Map<int, List<int>> songLyricPlaylists = {};
    Map<int, List<PlaylistEntity>> playlists = {};

    for (final songbook in await songbooks) _songbooks[songbook.id] = songbook;

    for (final songbookRecord in await SongbookRecordBean(_adapter).getAll()) {
      if (!songbookRecords.containsKey(songbookRecord.songLyricId)) songbookRecords[songbookRecord.songLyricId] = [];

      songbookRecords[songbookRecord.songLyricId].add(songbookRecord);
    }

    for (final songLyricTag in await SongLyricTagBean(_adapter).getAll()) {
      if (!songLyricTags.containsKey(songLyricTag.songLyricId)) songLyricTags[songLyricTag.songLyricId] = [];

      songLyricTags[songLyricTag.songLyricId].add(TagEntity(id: songLyricTag.tagId));
    }

    for (final author in await AuthorBean(_adapter).getAll()) authors[author.id] = author;

    for (final songLyricAuthor in await SongLyricAuthorBean(_adapter).getAll()) {
      if (!songLyricAuthors.containsKey(songLyricAuthor.songLyricId))
        songLyricAuthors[songLyricAuthor.songLyricId] = [];

      songLyricAuthors[songLyricAuthor.songLyricId].add(authors[songLyricAuthor.authorId]);
    }

    for (final ext in await ExternalBean(_adapter).getAll()) {
      if (!externals.containsKey(ext.songLyricId)) externals[ext.songLyricId] = [];

      externals[ext.songLyricId].add(ext);
    }

    for (final songlyricPlaylist in await SongLyricPlaylistBean(_adapter).getAll()) {
      if (!songLyricPlaylists.containsKey(songlyricPlaylist.playlistId))
        songLyricPlaylists[songlyricPlaylist.playlistId] = [];

      songLyricPlaylists[songlyricPlaylist.playlistId].add(songlyricPlaylist.songLyricId);
    }

    for (final playlist in await PlaylistBean(_adapter).getAll().catchError((error) => print(error))) {
      // fixme: should not be needed
      if (songLyricPlaylists.containsKey(playlist.id)) {
        for (final songLyricId in songLyricPlaylists[playlist.id]) {
          if (!playlists.containsKey(songLyricId)) playlists[songLyricId] = [];

          playlists[songLyricId].add(playlist);
        }
      }
    }

    for (SongLyricEntity songLyric in songLyrics) {
      songLyric.songbookRecords = songbookRecords[songLyric.id] ?? [];
      songLyric.tags = songLyricTags[songLyric.id] ?? [];
      songLyric.authors = songLyricAuthors[songLyric.id] ?? [];
      songLyric.externals = externals[songLyric.id] ?? [];
      songLyric.playlists = playlists[songLyric.id] ?? [];
    }

    return songLyrics;
  }

  Future<List<PlaylistEntity>> get playlists {
    final bean = PlaylistBean(_adapter);

    return bean.getAll().catchError((error) => print(error));
  }

  Future<void> removePlaylist(PlaylistEntity playlist) {
    PlaylistBean(_adapter).remove(playlist.id);
    return SongLyricPlaylistBean(_adapter).removeByPlaylistEntity(playlist.id);
  }

  Future<List<Map<String, dynamic>>> searchSongLyrics(String searchText) => _adapter.connection.rawQuery(
      "SELECT id, matchinfo(song_lyrics_search, 'pcnalx') as info FROM song_lyrics_search WHERE song_lyrics_search MATCH ?;",
      [searchText]).catchError((error) => print(error));

  Future<void> _removeOutdated<T>(List<int> ids, EntityBean<T> bean) async {
    final existing = [];

    for (final entity in await _adapter.connection.query(bean.tableName, columns: ['id'])) existing.add(entity['id']);

    for (final id in existing) if (!ids.contains(id)) await bean.remove(id, cascade: true);
  }

  Future<void> _insertOrUpdateMany<T extends Entity>(List<T> entities, EntityBean<T> bean, {Set<String> only}) async {
    final existing = {};

    for (final entity in await _adapter.connection.query(bean.tableName, columns: ['id']))
      existing[entity['id']] = true;

    List<T> inserts = [];
    List<T> updates = [];

    for (final entity in entities) {
      if (existing.containsKey(entity.id))
        updates.add(entity);
      else
        inserts.add(entity);
    }

    for (final batch in _splitInBatches(updates))
      await bean.updateMany(batch, only: only).catchError((error) => print(error));

    for (final batch in _splitInBatches(inserts)) await bean.insertMany(batch).catchError((error) => print(error));
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
