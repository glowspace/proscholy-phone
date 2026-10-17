import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:proscholy_common/utils/client.dart';

class _FakeLink extends Link {
  int requestsCount = 0;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    requestsCount++;

    return Stream.value(
      Response(
        data: {
          '__typename': 'Query',
          'news_items': [
            {
              '__typename': 'NewsItem',
              'id': '$requestsCount',
              'text': 'Novinka',
              'link': 'https://zpevnik.proscholy.cz',
              'expires_at': null,
            },
          ],
        },
        response: const {},
      ),
    );
  }
}

void main() {
  test('responses are not cached', () async {
    final link = _FakeLink();
    final client = Client(link: link);

    await client.getNews();
    final news = await client.getNews();

    expect(link.requestsCount, 2);
    expect(news['news_items'][0]['id'], '2');
  });
}
