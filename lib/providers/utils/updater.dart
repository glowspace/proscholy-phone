import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/author.dart';
import 'package:zpevnik/models/song.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/utils/client.dart';

class Updater {
  final Store store;

  Updater(this.store);

  final updateProgress = ValueNotifier(0);
  int updatingSongLyricsCount = 0;

  bool get isUpdating => updateProgress.value < updatingSongLyricsCount;

  Future<void> loadInitial() async {
    final json = jsonDecode(await rootBundle.loadString('assets/data.json'));

    await _parse(json['data']);
  }

  Future<void> update() async {
    final client = Client();

    final data = await client.getData();
    final songLyricIds = data['song_lyrics'].map((json) => int.parse(json['id'])).toList();

    updatingSongLyricsCount = songLyricIds.length;
    updateProgress.value = 1340;

    final List<Future> futures = [];

    // for (final songLyricId in songLyricIds) {
    //   futures.add(client.getSongLyric(songLyricId).then((json) => updateProgress.value += 1));
    // }

    await Future.wait(futures);

    client.dispose();
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

// import 'dart:convert';

// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart';
// import 'package:intl/intl.dart';
// import 'package:path/path.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:zpevnik/constants.dart';
// import 'package:zpevnik/models/model.dart';
// import 'package:zpevnik/models/song_lyrics_search.dart';
// import 'package:zpevnik/utils/exceptions.dart';

// const _versionKey = 'version';
// const lastUpdateKey = 'last_update';

// const _lastUpdatePlaceholder = '[LAST_UPDATE]';
// const _initialLastUpdate = '2021-09-28 9:47:00';

// const _updatePeriod = Duration(hours: 12);
// final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

// const _idPlaceholder = '[ID]';

// const _songLyricFields = '''
//   id
//   name
//   secondary_name_1
//   secondary_name_2
//   lyrics
//   lilypond_svg
//   lang
//   lang_string
//   type_enum
//   song {
//     id
//   }
//   songbook_records {
//     id
//     number
//     songbook {
//       id
//     }
//   }
//   externals {
//     id
//     public_name
//     media_id
//     media_type
//     authors {
//       id
//     }
//   }
//   authors_pivot {
//     author {
//       id
//     }
//   }
//   tags {
//     id
//   }
// ''';

// const _songLyricQuery = '''
//   {
//     "query": "query {
//       song_lyric(id: $_idPlaceholder) {
//         $_songLyricFields
//       }
//     }"
//   }
// ''';

// const _query = '''
//   {
//     "query": "query {
//       authors {
//         id
//         name
//       }
//       tags_enum {
//         id
//         name
//         type_enum
//       }
//       songbooks {
//         id
//         name
//         shortcut
//         color
//         color_text
//         is_private
//       }
//       songs {
//           id
//           name
//       }
//       song_lyrics$_lastUpdatePlaceholder {
//         $_songLyricFields
//       }
//       song_lyric_ids: song_lyrics {
//         id
//       }
//       external_ids: externals {
//         id
//       }
//     }"
//   }
//   ''';

// final _url = Uri.https('zpevnik.proscholy.cz', 'graphql');

// class Updater {
//   Future<void> update(bool forceUpdate) async {
//     final prefs = await SharedPreferences.getInstance();
//     final connectivityResult = await Connectivity().checkConnectivity();

//     final version = prefs.getInt(_versionKey);

//     if (version != kCurrentVersion) {
//       await _parse(await rootBundle.loadString('assets/data.json'));

//       prefs.setInt(_versionKey, kCurrentVersion);
//       prefs.remove(lastUpdateKey);
//     }

//     // temporary, can be removed after some time, when every installed app should be fixed
//     if (version == 6) await _fixPlaylistRecords();

//     if (version != null && version < 6)
//       try {
//         await _migrateOldDB();
//       } on Exception {}

//     if (forceUpdate || connectivityResult == ConnectivityResult.wifi) await _update(forceUpdate);
//   }

//   Future<void> _update(bool forceUpdate) async {
//     final prefs = await SharedPreferences.getInstance();
//     final lastUpdate = _dateFormat.parse(prefs.getString(lastUpdateKey) ?? _initialLastUpdate);

//     final now = DateTime.now();

//     if (!forceUpdate && !lastUpdate.isBefore(now.subtract(_updatePeriod))) return;

//     final query = _query
//         .replaceAll('\n', '')
//         .replaceFirst(_lastUpdatePlaceholder, '(updated_after: \\"${_dateFormat.format(lastUpdate.toUtc())}\\")');

//     try {
//       final response = await _postQuery(query);

//       await _parse(response.body, isUpdate: true);

//       prefs.setString(lastUpdateKey, _dateFormat.format(now));
//     } on Exception catch (e) {
//       throw UpdateException(e.toString());
//     }
//   }

//   Future<void> _parse(String body, {bool isUpdate = false}) async {
//     final data = (jsonDecode(body) as Map<String, dynamic>)['data'];

//     if (data == null) return;

//     final authors = await Author.fromMapList(data['authors']);
//     final tags = await Tag.fromMapList(data['tags_enum']);
//     final songbooks = await Songbook.fromMapList(data['songbooks']);
//     final songs = await Song.fromMapList(data['songs']);

//     final authorsMap = Map<int, Author>.fromIterable(authors, key: (author) => author.id);
//     final tagsMap = Map<int, Tag>.fromIterable(tags, key: (tag) => tag.id);

//     final externals = List<External>.empty(growable: true);
//     final songbookRecords = List<SongbookRecord>.empty(growable: true);
//     final songLyrics = List<SongLyric>.empty(growable: true);

//     final songLyricAuthors = List<Song_lyricsAuthors>.empty(growable: true);
//     final songLyricTags = List<Song_lyricsTags>.empty(growable: true);

//     for (final songLyricData in data['song_lyrics']) {
//       songLyrics.add(_parseSongLyric(
//           songLyricData, authorsMap, tagsMap, songLyricAuthors, externals, songbookRecords, songLyricTags));
//     }

//     final favorites =
//         await SongLyric().select(columnsToSelect: ['id']).favorite_rank.not.isNull().orderBy('favorite_rank').toList();

//     await Future.wait([
//       Author().upsertAll(authors),
//       Tag().upsertAll(tags),
//       Songbook().upsertAll(songbooks),
//       Song().upsertAll(songs),
//       SongLyric().upsertAll(songLyrics),
//       SongbookRecord().upsertAll(songbookRecords),
//       External().upsertAll(externals),
//       Song_lyricsAuthors().upsertAll(songLyricAuthors),
//       Song_lyricsTags().upsertAll(songLyricTags),
//       Model().updateSongLyricsSearch(songLyrics, songbooks, songbookRecords),
//     ]);

//     for (var i = 0; i < favorites.length; i++)
//       await SongLyric().select().id.equals(favorites[i].id).update({'favorite_rank': i});

//     if (isUpdate) {
//       final allSongLyrics =
//           List<int>.from(data['song_lyric_ids'].map((songLyric) => int.tryParse(songLyric['id']) ?? 0));

//       await _checkSongLyrics(allSongLyrics, authorsMap, tagsMap, songbooks);
//     }
//   }

//   Future<void> _checkSongLyrics(
//     List<int> allSongLyrics,
//     Map<int, Author> authorsMap,
//     Map<int, Tag> tagsMap,
//     List<Songbook> songbooks,
//   ) async {
//     final existingSongLyrics =
//         Map.fromIterable(await SongLyric().select(columnsToSelect: ['id']).toList(), key: (songLyric) => songLyric.id);

//     final externals = List<External>.empty(growable: true);
//     final songbookRecords = List<SongbookRecord>.empty(growable: true);
//     final songLyrics = List<SongLyric>.empty(growable: true);

//     final songLyricAuthors = List<Song_lyricsAuthors>.empty(growable: true);
//     final songLyricTags = List<Song_lyricsTags>.empty(growable: true);

//     for (final songLyricId in allSongLyrics) {
//       if (!existingSongLyrics.containsKey(songLyricId))
//         songLyrics.add(await _loadSongLyric(
//             songLyricId, authorsMap, tagsMap, songLyricAuthors, externals, songbookRecords, songLyricTags));

//       existingSongLyrics.remove(songLyricId);
//     }

//     for (final songLyric in existingSongLyrics.values) songLyric.delete(true);

//     await Future.wait([
//       External().upsertAll(externals),
//       SongbookRecord().upsertAll(songbookRecords),
//       SongLyric().upsertAll(songLyrics),
//       Song_lyricsAuthors().upsertAll(songLyricAuthors),
//       Song_lyricsTags().upsertAll(songLyricTags),
//       Model().updateSongLyricsSearch(songLyrics, songbooks, songbookRecords)
//     ]);
//   }

//   Future<SongLyric> _loadSongLyric(
//     int songLyricId,
//     Map<int, Author> authorsMap,
//     Map<int, Tag> tagsMap,
//     List<Song_lyricsAuthors> songLyricAuthors,
//     List<External> externals,
//     List<SongbookRecord> songbookRecords,
//     List<Song_lyricsTags> songLyricTags,
//   ) async {
//     final query = _songLyricQuery.replaceAll('\n', '').replaceFirst(_idPlaceholder, songLyricId.toString());

//     final response = await _postQuery(query);

//     final data = (jsonDecode(response.body) as Map<String, dynamic>)['data'];

//     return _parseSongLyric(
//       data['song_lyric'],
//       authorsMap,
//       tagsMap,
//       songLyricAuthors,
//       externals,
//       songbookRecords,
//       songLyricTags,
//     );
//   }

//   SongLyric _parseSongLyric(
//     Map<String, dynamic> songLyricData,
//     Map<int, Author> authorsMap,
//     Map<int, Tag> tagsMap,
//     List<Song_lyricsAuthors> songLyricAuthors,
//     List<External> externals,
//     List<SongbookRecord> songbookRecords,
//     List<Song_lyricsTags> songLyricTags,
//   ) {
//     final songLyric = SongLyric.fromMap(songLyricData)
//       ..songsId = int.tryParse(songLyricData['song']?['id']?.toString() ?? '');

//     if (songLyricData['authors_pivot'] != null) {
//       for (final authorData in songLyricData['authors_pivot']) {
//         final authorId = int.tryParse(authorData['author']['id'].toString());
//         if (authorsMap.containsKey(authorId))
//           songLyricAuthors.add(Song_lyricsAuthors(song_lyricsId: songLyric.id, authorsId: authorId));
//       }
//     }

//     for (final externalsData in songLyricData['externals']) {
//       final external = External.fromMap(externalsData)..song_lyricsId = songLyric.id;

//       externals.add(external);
//     }

//     for (final songbookRecordData in songLyricData['songbook_records']) {
//       final songbookRecord = SongbookRecord.fromMap(songbookRecordData)
//         ..song_lyricsId = songLyric.id
//         ..songbooksId = int.tryParse(songbookRecordData['songbook']['id']);

//       songbookRecords.add(songbookRecord);
//     }

//     if (songLyricData['tags'] != null) {
//       for (final tagData in songLyricData['tags']) {
//         final tagId = int.tryParse(tagData['id'].toString());
//         if (tagsMap.containsKey(tagId)) songLyricTags.add(Song_lyricsTags(song_lyricsId: songLyric.id, tagsId: tagId));
//       }
//     }

//     return songLyric;
//   }

//   Future<void> _migrateOldDB() async {
//     final db = await openDatabase(join(await getDatabasesPath(), 'zpevnik.db'));

//     final songLyrics =
//         await db.query('song_lyrics', columns: ['id', 'favorite_order'], where: 'favorite_order IS NOT NULL');

//     for (final songLyric in songLyrics)
//       await SongLyric().select().id.equals(songLyric['id']).update({'favorite_rank': songLyric['favorite_order']});

//     final playlistsOld = await db.query('playlists');
//     final playlists = List<Playlist>.empty(growable: true);

//     for (final playlist in playlistsOld)
//       playlists.add(Playlist(
//         id: playlist['id'] as int?,
//         name: playlist['name'] as String?,
//         is_archived: (playlist['is_archived'] as int?) == 1,
//         rank: playlist['order_value'] as int?,
//       ));

//     await Playlist().upsertAll(playlists);

//     final songLyricPlaylistsOld = await db.query('song_lyrics_playlists');
//     final songLyricPlaylists = List<PlaylistRecord>.empty(growable: true);

//     int rank = 0;
//     for (final songLyricPlaylist in songLyricPlaylistsOld)
//       songLyricPlaylists.add(PlaylistRecord(
//         playlistsId: songLyricPlaylist['playlist_id'] as int?,
//         song_lyricsId: songLyricPlaylist['song_lyric_id'] as int?,
//         rank: rank++,
//       ));

//     await PlaylistRecord().upsertAll(songLyricPlaylists);
//   }

//   Future<void> _fixPlaylistRecords() async {
//     final playlistRecords = await PlaylistRecord().select().toList();

//     // needs to be dropped, because primary key was changed and this library doesn't support migration of this
//     await Model().execSQL('DROP TABLE playlist_records;');

//     Model().databaseTables?.forEach((table) {
//       if (table is TablePlaylistRecord) table.initialized = false;
//     });

//     await Model().initializeDB();

//     playlistRecords.forEach((element) => element.id = null);

//     await PlaylistRecord.saveAll(playlistRecords);
//   }

//   Future<Response> _postQuery(String body) =>
//       Client().post(_url, body: body, headers: {'Content-Type': 'application/json; charset=utf-8'});
// }
