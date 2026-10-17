import 'package:flutter_test/flutter_test.dart';
import 'package:gql/ast.dart';
import 'package:gql/language.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:proscholy_common/utils/api_client.dart';

class _FakeLink extends Link {
  final requests = <Request>[];

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    requests.add(request);

    return Stream.value(
      Response(
        data: {
          '__typename': 'Query',
          'news_items': [
            {
              '__typename': 'NewsItem',
              'id': '${requests.length}',
              'text': 'Novinka',
              'link': 'https://zpevnik.proscholy.cz',
              'expires_at': null,
            },
          ],
          'song_lyrics': [],
          'song_lyric': {'__typename': 'SongLyric', 'id': '1'},
        },
        response: const {},
      ),
    );
  }
}

// fields requested for song lyrics by the only query in request
String _songLyricFields(Request request) {
  final operation = request.operation.document.definitions.single as OperationDefinitionNode;

  final field = operation.selectionSet.selections.whereType<FieldNode>().singleWhere(
    (field) => field.name.value != '__typename',
  );

  return printNode(field.selectionSet!);
}

void main() {
  test('responses are not cached', () async {
    final link = _FakeLink();
    final client = ApiClient(link: link);

    await client.getNews();
    final news = await client.getNews();

    expect(link.requests, hasLength(2));
    expect(news['news_items'][0]['id'], '2');
  });

  // e.g. EZ and EK take names of song lyrics from their songbook records
  test('updated and missing song lyrics are fetched with same fields', () async {
    final link = _FakeLink();
    final client = ApiClient(link: link);

    await client.getSongLyrics(DateTime(2026));
    await client.getSongLyric(1);

    expect(_songLyricFields(link.requests[1]), _songLyricFields(link.requests[0]));
  });

  test('date and id are sent as variables', () async {
    final link = _FakeLink();
    final client = ApiClient(link: link);

    await client.getSongLyrics(DateTime(2026, 1, 2, 3, 4, 5));
    await client.getSongLyric(1);

    expect(link.requests[0].variables, {'updated_after': '2026-01-02 03:04:05'});
    expect(link.requests[1].variables, {'id': 1});
  });
}
