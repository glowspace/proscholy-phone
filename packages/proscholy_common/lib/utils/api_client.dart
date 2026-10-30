import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:proscholy_common/constants.dart';

final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

final _link = HttpLink(
  'https://zpevnik.proscholy.cz/graphql',
  defaultHeaders: {if (isEZ) 'Filter-Content': 'ez' else if (isEK) 'Filter-Content': 'ek'},
);

const _newsQuery = '''
query {
  news_items(active: true) {
    id
    text
    link
    expires_at
  }
}''';

// tags of other types are not shown, EZ and EK show no tags
const _tagTypes = isZPS ? ['LITURGY_PART', 'LITURGY_PERIOD', 'SACRED_OCCASION', 'GENERIC', 'SAINTS'] : <String>[];

final _updateQuery =
    '''
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
  }
  song_lyrics {
    id
    is_arrangement
  }
${[for (final type in _tagTypes) '  $type: tags_enum(type: $type) { id name type_enum song_lyrics_count }'].join('\n')}
}''';

// same fields are needed for updated and missing song lyrics
const _songLyricFields =
    '''
    id
    name
    secondary_name_1
    secondary_name_2
    lyrics
    ${isEZ || isEK ? 'hymnology' : ''}
    lang
    lang_string
    type_enum
    is_arrangement
    has_chords
    song {
      id
    }
    songbook_records {
      pivot {
        id
        number
        ${isEZ || isEK ? 'song_name' : ''}
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
      content_type
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
    }''';

const _songLyricsQuery =
    '''
query(\$updated_after: DateTime!) {
  song_lyrics(updated_after: \$updated_after) {
$_songLyricFields
  }
}''';

const _songLyricQuery =
    '''
query(\$id: ID!) {
  song_lyric(id: \$id) {
$_songLyricFields
  }
}''';

class ApiClient {
  final GraphQLClient client;

  ApiClient({Link? link})
    : client = GraphQLClient(
        link: link ?? _link,
        cache: GraphQLCache(),
        // by default results are cached, so later updates would get old data and cache would keep all data in memory
        defaultPolicies: DefaultPolicies(query: Policies(fetch: FetchPolicy.noCache)),
        // graphql completes request again when response comes after its timeout, so timeout is applied in `_query`
        queryRequestTimeout: null,
      );

  Future<Map<String, dynamic>> getNews() async {
    return _query(QueryOptions(document: gql(_newsQuery)));
  }

  Future<Map<String, dynamic>> getData() async {
    final data = await _query(QueryOptions(document: gql(_updateQuery)));

    // tags of each type come in their own list
    return {
      ...data,
      'tags_enum': [for (final type in _tagTypes) ...?data[type]],
    };
  }

  Future<Map<String, dynamic>> getSongLyrics(DateTime updatedAfter) async {
    return _query(
      QueryOptions(document: gql(_songLyricsQuery), variables: {'updated_after': _dateFormat.format(updatedAfter)}),
    );
  }

  Future<Map<String, dynamic>> getSongLyric(int id) async {
    final data = await _query(QueryOptions(document: gql(_songLyricQuery), variables: {'id': id}));

    return data['song_lyric'];
  }

  Future<List<int>> getSvgs(DateTime updatedAfter) async {
    final response = await http.get(
      Uri.https('zpevnik.proscholy.cz', 'download-svgs', {'updated_after': _dateFormat.format(updatedAfter)}),
    );

    return response.bodyBytes;
  }

  Future<Map<String, dynamic>> _query(QueryOptions options) async {
    final result = await client.query(options).timeout(const Duration(seconds: 60));

    if (result.hasException) throw result.exception!;

    return result.data!;
  }
}
