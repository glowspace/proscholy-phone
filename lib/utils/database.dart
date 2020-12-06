import 'dart:math';

import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zpevnik/models/entities/author.dart';
import 'package:zpevnik/models/entities/external.dart';
import 'package:zpevnik/models/entities/playlist.dart';
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
  }

  Future<void> saveAuthors(List<AuthorEntity> authors) async {
    for (final batch in _splitInBatches(authors))
      await AuthorBean(_adapter).upsertMany(batch).catchError((error) => print(error));
  }

  Future<void> saveTags(List<TagEntity> tags) => TagBean(_adapter).upsertMany(tags).catchError((error) => print(error));

  Future<void> saveSongbooks(List<SongbookEntity> songbooks) =>
      SongbookBean(_adapter).upsertMany(songbooks).catchError((error) => print(error));

  Future<void> saveSongs(List<SongEntity> songs) async {
    for (final batch in _splitInBatches(songs))
      await SongBean(_adapter).upsertMany(batch).catchError((error) => print(error));
  }

  Future<void> saveSongLyrics(List<SongLyricEntity> songLyrics) async {
    for (final batch in _splitInBatches(songLyrics))
      await SongLyricBean(_adapter).upsertMany(batch).catchError((error) => print(error));
  }

  Future<void> saveExternals(List<ExternalEntity> externals) async {
    for (final batch in _splitInBatches(externals))
      await ExternalBean(_adapter).upsertMany(batch).catchError((error) => print(error));
  }

  Future<void> saveSongbookRecords(List<SongbookRecord> songbookRecords) =>
      SongbookRecordBean(_adapter).upsertMany(songbookRecords).catchError((error) => print(error));

  Future<void> saveSongLyricTags(List<SongLyricTag> songLyricTags) =>
      SongLyricTagBean(_adapter).upsertMany(songLyricTags).catchError((error) => print(error));

  Future<void> saveSongLyricAuthors(List<SongLyricAuthor> songLyricAuthors) =>
      SongLyricAuthorBean(_adapter).upsertMany(songLyricAuthors).catchError((error) => print(error));

  void savePlaylist(PlaylistEntity playlist) {
    PlaylistBean(_adapter).insert(playlist).catchError((error) => print(error));
    SongLyricPlaylistBean(_adapter)
        .insertMany(playlist.songLyrics
            .map((songLyric) => SongLyricPlaylist()
              ..playlistId = playlist.id
              ..songLyricId = songLyric.id)
            .toList())
        .catchError((error) => print(error));
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
