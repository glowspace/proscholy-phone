import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zpevnik/models/entities/author.dart';
import 'package:zpevnik/models/entities/song.dart';
import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/models/entities/songbook.dart';
import 'package:zpevnik/models/entities/tag.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/utils/beans.dart';
import 'package:zpevnik/utils/database.dart';

const String _initialLoadKey = 'initial_load';
const String _lastUpdateKey = 'last_update';

const String _lastUpdatePlaceholder = '[LAST_UPDATE]';

const Duration _updatePeriod = Duration(hours: 12);

class Updater {
  Updater._();

  static final Updater shared = Updater._();

  final String _url = 'https://zpevnik.proscholy.cz/graphql';

  final String _query = '''
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
        id
        name
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
      }
    }"
  }
  ''';

  Future<bool> update() async {
    final prefs = await SharedPreferences.getInstance();
    final connectivityResult = await Connectivity().checkConnectivity();

    await Database.shared.init();

    if (connectivityResult == ConnectivityResult.wifi) {
      if (prefs.containsKey(_initialLoadKey))
        _update(prefs.getString(_lastUpdateKey));
      else
        await _update(null);
    } else if (!prefs.containsKey(_initialLoadKey)) await _loadLocal();

    await DataProvider.shared.init();

    return true;
  }

  Future<void> _update(String lastUpdate) async {
    final format = DateFormat('yyyy-MM-dd HH:mm:ss');
    if (lastUpdate != null && format.parse(lastUpdate).isBefore(DateTime.now().subtract(_updatePeriod))) return;

    final response = await Client().post(_url,
        body: _query
            .replaceAll('\n', '')
            .replaceFirst(_lastUpdatePlaceholder, lastUpdate == null ? '' : '(updated_after: \\"$lastUpdate\\")'),
        headers: <String, String>{'Content-Type': 'application/json; charset=utf-8'});

    await _parse(response.body);
    SharedPreferences.getInstance().then((prefs) => prefs.setString(_lastUpdateKey, format.format(DateTime.now())));
  }

  Future<void> _loadLocal() async => _parse(await rootBundle.loadString('assets/data.json'));

  Future<void> _parse(String body) async {
    final data = (jsonDecode(body) as Map<String, dynamic>)['data'];

    if (data == null) return;

    final authors = (data['authors'] as List<dynamic>).map((json) => AuthorEntity.fromJson(json)).toList();

    final tags = (data['tags_enum'] as List<dynamic>).map((json) => TagEntity.fromJson(json)).toList();

    final songbooks = (data['songbooks'] as List<dynamic>).map((json) => SongbookEntity.fromJson(json)).toList();

    final songs = (data['songs'] as List<dynamic>).map((json) => SongEntity.fromJson(json)).toList();

    final songLyrics = (data['song_lyrics'] as List<dynamic>).map((json) => SongLyricEntity.fromJson(json)).toList();

    await Future.wait([
      Database.shared.saveAuthors(authors),
      Database.shared.saveTags(tags),
      Database.shared.saveSongbooks(songbooks),
      Database.shared.saveSongs(songs),
      Database.shared.saveSongLyrics(songLyrics),
      Database.shared.saveExternals(songLyrics.map((songLyric) => songLyric.externals).reduce((result, list) {
        result.addAll(list);
        return result;
      })),
      Database.shared
          .saveSongbookRecords(songLyrics.map((songLyric) => songLyric.songbookRecords).toList().reduce((result, list) {
        result.addAll(list);
        return result;
      }).toList()),
      Database.shared.saveSongLyricTags(songLyrics
          .map((songLyric) => List.generate(
              songLyric.tags.length,
              (index) => SongLyricTag()
                ..songLyricId = songLyric.id
                ..tagId = songLyric.tags[index].id))
          .toList()
          .reduce((result, list) {
        result.addAll(list);
        return result;
      })),
      Database.shared.saveSongLyricAuthors(songLyrics
          .map((songLyric) => List.generate(
              songLyric.authors.length,
              (index) => SongLyricAuthor()
                ..songLyricId = songLyric.id
                ..authorId = songLyric.authors[index].id))
          .toList()
          .reduce((result, list) {
        result.addAll(list);
        return result;
      })),
    ]).then((_) => SharedPreferences.getInstance().then((prefs) => prefs.setBool(_initialLoadKey, true)));
  }
}
