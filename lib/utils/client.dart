import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pool/pool.dart';

const _poolSize = 5;

final _url = Uri.https('zpevnik.proscholy.cz', 'graphql');

const _newsQuery = '''
query {
  news_items(active: true) {
    id
    text
    link
    expires_at
  }
}''';

const _updateQuery = '''
query {
  authors {
    id
    name
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
  song_lyrics {
    id
    updated_at
  }
  tags_enum {
    id
    name
    type_enum
  }
}''';

const _idPlaceholder = '[ID]';

const _songLyricQuery = '''
query {
  song_lyric(id: $_idPlaceholder) {
    id
    name
    secondary_name_1
    secondary_name_2
    lyrics
    lilypond_svg
    lang
    lang_string
    type_enum
    has_chords
    song {
      id
    }
    songbook_records {
      pivot {
        id
        number
        songbook {
          id
        }
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
      pivot {
        author {
          id
        }
      }
    }
    tags {
      id
    }
  }
}''';

class Client {
  final http.Client client;
  final Pool pool;

  Client()
      : client = http.Client(),
        pool = Pool(_poolSize);

  Future<Map<String, dynamic>> getNews() async {
    final body = {'query': _newsQuery};

    final response = await pool.withResource(() => client.post(_url, body: body));

    return jsonDecode(response.body)['data'];
  }

  Future<Map<String, dynamic>> getData() async {
    final body = {'query': _updateQuery};

    final response = await pool.withResource(() => client.post(_url, body: body));

    return jsonDecode(response.body)['data'];
  }

  Future<Map<String, dynamic>> getSongLyric(int id) async {
    final body = {'query': _songLyricQuery.replaceFirst(_idPlaceholder, '$id')};

    final response = await pool.withResource(() => client.post(_url, body: body));

    return jsonDecode(response.body)['data']['song_lyric'];
  }

  void dispose() {
    client.close();
    pool.close();
  }
}
