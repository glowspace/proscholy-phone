import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zpevnik/models/entities/author.dart';
import 'package:zpevnik/models/entities/song.dart';
import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/models/entities/songbook.dart';
import 'package:zpevnik/models/entities/tag.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/utils/database.dart';

class UpdateProvider extends ChangeNotifier {
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
        is_private
      }
      songs {
          id
          name
      }
      song_lyrics {
        id
        name
        lyrics
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
          type
          type_string
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

  String _progressInfo;
  String get progressInfo => _progressInfo;

  UpdateProvider() {
    _progressInfo = '';
  }

  Future<bool> update() async {
    final prefs = await SharedPreferences.getInstance();

    await Database.shared.init();

    if (!prefs.containsKey('loaded')) {
      await _loadLocal();

      await prefs.setBool('loaded', true);
    }

    // todo: handle initial load + updating
    // await _update();

    await DataProvider.shared.init();

    return true;
  }

  Future<void> _update() async {
    _progressInfo = 'Aktualizace písní';
    notifyListeners();

    final response = await Client().post(_url,
        body: _query.replaceAll('\n', ''),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8'
        });

    _parse(response.body);
  }

  Future<void> _loadLocal() async =>
      _parse(await rootBundle.loadString('assets/data.json'));

  Future<void> _parse(String body) async {
    _progressInfo = 'Příprava písní';
    notifyListeners();

    final data = (jsonDecode(body) as Map<String, dynamic>)['data'];

    if (data == null) return;

    await Database.shared.saveAuthors((data['authors'] as List<dynamic>)
        .map((json) => Author.fromJson(json))
        .toList());

    await Database.shared.saveTags((data['tags_enum'] as List<dynamic>)
        .map((json) => TagEntity.fromJson(json))
        .toList());

    await Database.shared.saveSongbooks((data['songbooks'] as List<dynamic>)
        .map((json) => Songbook.fromJson(json))
        .toList());

    await Database.shared.saveSongs((data['songs'] as List<dynamic>)
        .map((json) => Song.fromJson(json))
        .toList());

    await Database.shared.saveSongLyrics((data['song_lyrics'] as List<dynamic>)
        .map((json) => SongLyric.fromJson(json))
        .toList());
  }
}
