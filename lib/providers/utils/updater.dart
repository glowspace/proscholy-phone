import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/song_lyrics_search.dart';
import 'package:zpevnik/utils/exceptions.dart';

const _versionKey = 'version';
const lastUpdateKey = 'last_update';

const _lastUpdatePlaceholder = '[LAST_UPDATE]';
const _initialLastUpdate = '2021-03-06 11:30:00';

const _updatePeriod = Duration(hours: 12);
final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

const _idPlaceholder = '[ID]';

const _songLyricFields = '''
  id
  name
  secondary_name_1
  secondary_name_2
  lyrics
  lilypond_svg
  lang
  lang_string
  type_enum
  song {
    id
  }
  songbook_records {
    id
    number
    songbook {
      id
    }
  }
  externals {
    id
    public_name
    media_id
    media_type
    authors {
      id
    }
  }
  authors_pivot {
    author {
      id
    }
  }
  tags {
    id
  }
''';

const _songLyricQuery = '''
  {
    "query": "query {
      song_lyric(id: $_idPlaceholder) {
        $_songLyricFields
      }
    }"
  }
''';

const _query = '''
  {
    "query": "query {
      authors {
        id
        name
      }
      tags_enum {
        id
        name
        type_enum
      }
      songbooks {
        id
        name
        shortcut
        color
        color_text
        is_private
      }
      songs {
          id
          name
      }
      song_lyrics$_lastUpdatePlaceholder {
        $_songLyricFields
      }
      song_lyric_ids: song_lyrics {
        id
      }
      external_ids: externals {
        id
      }
    }"
  }
  ''';

final _url = Uri.https('zpevnik.proscholy.cz', 'graphql');

class Updater {
  Future<void> update(bool forceUpdate) async {
    final prefs = await SharedPreferences.getInstance();
    final connectivityResult = await Connectivity().checkConnectivity();

    final version = prefs.getInt(_versionKey);

    if (version != kCurrentVersion) {
      await _parse(await rootBundle.loadString('assets/data.json'));

      prefs.setInt(_versionKey, kCurrentVersion);
    }

    if (forceUpdate || connectivityResult == ConnectivityResult.wifi) await _update(forceUpdate);

    if (version != null && version != kCurrentVersion) await _migrateOldDB();
  }

  Future<void> _update(bool forceUpdate) async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getString(lastUpdateKey) ?? _initialLastUpdate;

    final now = DateTime.now();

    if (!forceUpdate && !_dateFormat.parse(lastUpdate).isBefore(now.subtract(_updatePeriod))) return;

    final query =
        _query.replaceAll('\n', '').replaceFirst(_lastUpdatePlaceholder, '(updated_after: \\"$lastUpdate\\")');

    try {
      final response = await _postQuery(query);

      await _parse(response.body, isUpdate: true);
    } on Exception catch (e) {
      throw UpdateException(e.toString());
    }

    prefs.setString(lastUpdateKey, _dateFormat.format(now));
  }

  Future<void> _parse(String body, {bool isUpdate = false}) async {
    final data = (jsonDecode(body) as Map<String, dynamic>)['data'];

    if (data == null) return;

    final authors = await Author.fromMapList(data['authors']);
    final tags = await Tag.fromMapList(data['tags_enum']);
    final songbooks = await Songbook.fromMapList(data['songbooks']);
    final songs = await Song.fromMapList(data['songs']);

    final authorsMap = Map<int, Author>.fromIterable(authors, key: (author) => author.id);
    final tagsMap = Map<int, Tag>.fromIterable(tags, key: (tag) => tag.id);

    final externals = List<External>.empty(growable: true);
    final songbookRecords = List<SongbookRecord>.empty(growable: true);
    final songLyrics = List<SongLyric>.empty(growable: true);

    final songLyricAuthors = List<Song_lyricsAuthors>.empty(growable: true);
    final songLyricTags = List<Song_lyricsTags>.empty(growable: true);

    for (final songLyricData in data['song_lyrics']) {
      songLyrics.add(_parseSongLyric(
          songLyricData, authorsMap, tagsMap, songLyricAuthors, externals, songbookRecords, songLyricTags));
    }

    final favorites =
        await SongLyric().select(columnsToSelect: ['id']).favorite_rank.not.isNull().orderBy('favorite_rank').toList();

    await Author().upsertAll(authors);
    await Tag().upsertAll(tags);
    await Songbook().upsertAll(songbooks);
    await Song().upsertAll(songs);
    await SongLyric().upsertAll(songLyrics);
    await SongbookRecord().upsertAll(songbookRecords);
    await External().upsertAll(externals);
    await Song_lyricsAuthors().upsertAll(songLyricAuthors);
    await Song_lyricsTags().upsertAll(songLyricTags);

    for (var i = 0; i < favorites.length; i++)
      await SongLyric().select().id.equals(favorites[i].id).update({'favorite_rank': i});

    await Model().updateSongLyricsSearch(songLyrics, songbooks, songbookRecords);

    if (isUpdate) {
      final allSongLyrics =
          List<int>.from(data['song_lyric_ids'].map((songLyric) => int.tryParse(songLyric['id']) ?? 0));

      await _checkSongLyrics(allSongLyrics, authorsMap, tagsMap, songbooks);
    }
  }

  Future<void> _checkSongLyrics(
    List<int> allSongLyrics,
    Map<int, Author> authorsMap,
    Map<int, Tag> tagsMap,
    List<Songbook> songbooks,
  ) async {
    final existingSongLyrics =
        Map.fromIterable(await SongLyric().select(columnsToSelect: ['id']).toList(), key: (songLyric) => songLyric.id);

    final externals = List<External>.empty(growable: true);
    final songbookRecords = List<SongbookRecord>.empty(growable: true);
    final songLyrics = List<SongLyric>.empty(growable: true);

    final songLyricAuthors = List<Song_lyricsAuthors>.empty(growable: true);
    final songLyricTags = List<Song_lyricsTags>.empty(growable: true);

    for (final songLyricId in allSongLyrics) {
      if (!existingSongLyrics.containsKey(songLyricId))
        songLyrics.add(await _loadSongLyric(
            songLyricId, authorsMap, tagsMap, songLyricAuthors, externals, songbookRecords, songLyricTags));

      existingSongLyrics.remove(songLyricId);
    }

    for (final songLyric in existingSongLyrics.values) songLyric.delete(true);

    await External().upsertAll(externals);
    await SongbookRecord().upsertAll(songbookRecords);
    await SongLyric().upsertAll(songLyrics);
    await Song_lyricsAuthors().upsertAll(songLyricAuthors);
    await Song_lyricsTags().upsertAll(songLyricTags);

    await Model().updateSongLyricsSearch(songLyrics, songbooks, songbookRecords);
  }

  Future<SongLyric> _loadSongLyric(
    int songLyricId,
    Map<int, Author> authorsMap,
    Map<int, Tag> tagsMap,
    List<Song_lyricsAuthors> songLyricAuthors,
    List<External> externals,
    List<SongbookRecord> songbookRecords,
    List<Song_lyricsTags> songLyricTags,
  ) async {
    final query = _songLyricQuery.replaceAll('\n', '').replaceFirst(_idPlaceholder, songLyricId.toString());

    final response = await _postQuery(query);

    final data = (jsonDecode(response.body) as Map<String, dynamic>)['data'];

    return _parseSongLyric(
      data['song_lyric'],
      authorsMap,
      tagsMap,
      songLyricAuthors,
      externals,
      songbookRecords,
      songLyricTags,
    );
  }

  SongLyric _parseSongLyric(
    Map<String, dynamic> songLyricData,
    Map<int, Author> authorsMap,
    Map<int, Tag> tagsMap,
    List<Song_lyricsAuthors> songLyricAuthors,
    List<External> externals,
    List<SongbookRecord> songbookRecords,
    List<Song_lyricsTags> songLyricTags,
  ) {
    final songLyric = SongLyric.fromMap(songLyricData)
      ..songsId = int.tryParse(songLyricData['song']?['id']?.toString() ?? '');

    if (songLyricData['authors_pivot'] != null) {
      for (final authorData in songLyricData['authors_pivot']) {
        final authorId = int.tryParse(authorData['author']['id'].toString());
        if (authorsMap.containsKey(authorId))
          songLyricAuthors.add(Song_lyricsAuthors(song_lyricsId: songLyric.id, authorsId: authorId));
      }
    }

    for (final externalsData in songLyricData['externals']) {
      final external = External.fromMap(externalsData)..song_lyricsId = songLyric.id;

      externals.add(external);
    }

    for (final songbookRecordData in songLyricData['songbook_records']) {
      final songbookRecord = SongbookRecord.fromMap(songbookRecordData)
        ..song_lyricsId = songLyric.id
        ..songbooksId = int.tryParse(songbookRecordData['songbook']['id']);

      songbookRecords.add(songbookRecord);
    }

    if (songLyricData['tags'] != null) {
      for (final tagData in songLyricData['tags']) {
        final tagId = int.tryParse(tagData['id'].toString());
        if (tagsMap.containsKey(tagId)) songLyricTags.add(Song_lyricsTags(song_lyricsId: songLyric.id, tagsId: tagId));
      }
    }

    return songLyric;
  }

  Future<void> _migrateOldDB() async {
    final db = await openDatabase(join(await getDatabasesPath(), 'zpevnik.db'));

    final songLyrics =
        await db.query('song_lyrics', columns: ['id', 'favorite_order'], where: 'favorite_order IS NOT NULL');

    for (final songLyric in songLyrics)
      await SongLyric().select().id.equals(songLyric['id']).update({'favorite_rank': songLyric['favorite_order']});

    final playlistsOld = await db.query('playlists');
    final playlists = List<Playlist>.empty(growable: true);

    for (final playlist in playlistsOld)
      playlists.add(Playlist(
        id: playlist['id'] as int?,
        name: playlist['name'] as String?,
        is_archived: (playlist['is_archived'] as int?) == 1,
        rank: playlist['order_value'] as int?,
      ));

    await Playlist().upsertAll(playlists);

    final songLyricPlaylistsOld = await db.query('song_lyrics_playlists');
    final songLyricPlaylists = List<Song_lyricsPlaylists>.empty(growable: true);

    for (final songLyricPlaylist in songLyricPlaylistsOld)
      songLyricPlaylists.add(Song_lyricsPlaylists(
          playlistsId: songLyricPlaylist['playlist_id'] as int?,
          song_lyricsId: songLyricPlaylist['song_lyric_id'] as int?));

    await Song_lyricsPlaylists().upsertAll(songLyricPlaylists);
  }

  Future<Response> _postQuery(String body) =>
      Client().post(_url, body: body, headers: {'Content-Type': 'application/json; charset=utf-8'});
}
