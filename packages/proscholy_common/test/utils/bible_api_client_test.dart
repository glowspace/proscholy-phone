import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:proscholy_common/models/bible_passage.dart';
import 'package:proscholy_common/utils/bible_api_client.dart';

void main() {
  test('failed request is made again', () async {
    var statusCode = 500;
    final client = MockClient((request) async {
      if (statusCode != 200) return http.Response('Server Error', statusCode);

      return http.Response.bytes(
        utf8.encode(
          jsonEncode({
            'verses': [
              {'text': 'Na počátku stvořil Bůh nebe a zemi.'},
            ],
          }),
        ),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    await http.runWithClient(() async {
      final container = ProviderContainer.test(retry: (_, _) => null);
      final provider = biblePassageProvider(supportedBibleTranslations[1], supportedBibleBooks[0], 1, 1);

      await expectLater(container.read(provider.future), throwsA(isA<http.ClientException>()));

      statusCode = 200;
      await container.pump();

      expect(await container.read(provider.future), 'Na počátku stvořil Bůh nebe a zemi.');
    }, () => client);
  });
}
