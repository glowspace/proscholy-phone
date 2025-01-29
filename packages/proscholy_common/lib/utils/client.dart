import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:proscholy_common/constants.dart';

final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

final _link = HttpLink('https://zpevnik.proscholy.cz/graphql', defaultHeaders: {if (isEZ) 'Filter-Content': 'ez'});

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
  }
  tags_enum {
    id
    name
    type_enum
    song_lyrics_count
  }
}''';

const _idPlaceholder = '[ID]';
const _updatedAfterPlaceholder = '[UPDATED_AFTER]';

const _ezAdditionalQueryFields = '''
    external_rendered_scores {
      contents
    }
    hymnology
''';

const _songLyricsQuery = '''
query {
  song_lyrics(updated_after: $_updatedAfterPlaceholder) {
    id
    name
    secondary_name_1
    secondary_name_2
    lyrics
    lilypond_svg${isEZ ? _ezAdditionalQueryFields : ''}
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
        song_lyric {
          id
        }
        songbook {
          id
        }
      }
    }
    externals {
      id
      public_name
      url
      media_id
      media_type
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

const _songLyricQuery = '''
query {
  song_lyric(id: $_idPlaceholder) {
    id
    name
    secondary_name_1
    secondary_name_2
    lyrics
    lilypond_svg${isEZ ? _ezAdditionalQueryFields : ''}
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
        song_lyric {
          id
        }
        songbook {
          id
        }
      }
    }
    externals {
      id
      public_name
      url
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
  final GraphQLClient client;

  Client() : client = GraphQLClient(link: _link, cache: GraphQLCache(), queryRequestTimeout: Duration(seconds: 20));

  Future<Map<String, dynamic>> getNews() async {
    final result = await client.query(QueryOptions(document: gql(_newsQuery)));

    return result.data!;
  }

  Future<Map<String, dynamic>> getData() async {
    final result = await client.query(QueryOptions(document: gql(_updateQuery)));

    return result.data!;
  }

  Future<Map<String, dynamic>> getSongLyrics(DateTime updatedAfter) async {
    final result = await client.query(
      QueryOptions(
        document: gql(_songLyricsQuery.replaceFirst(_updatedAfterPlaceholder, '"${_dateFormat.format(updatedAfter)}"')),
      ),
    );

    return result.data!;
  }

  Future<Map<String, dynamic>> getSongLyric(int id) async {
    final result = await client.query(QueryOptions(document: gql(_songLyricQuery.replaceFirst(_idPlaceholder, '$id'))));

    return result.data!['song_lyric'];
  }
}
