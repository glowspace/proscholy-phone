// benchmarks of requests to API, they load the server, so they run only with `--dart-define=LIVE_API=true`
// flutter test benchmark/api_benchmark_test.dart --dart-define=ZPEVNIK_TARGET=ZPS --dart-define=LIVE_API=true
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/utils/api_client.dart';

import 'utils.dart';

const _liveApi = bool.fromEnvironment('LIVE_API');

void main() {
  final benchmark = Benchmark('api');

  tearDownAll(benchmark.save);

  test('requests', skip: !_liveApi, timeout: const Timeout(Duration(minutes: 5)), () async {
    final client = ApiClient();
    final updatedAfter = DateTime.now().subtract(const Duration(days: 30));

    // size of response is approximated by size of its data encoded as json
    Map<String, Object> size(Map<String, dynamic> data) => {'bytes': utf8.encode(jsonEncode(data)).length};

    final news = await benchmark.measure('news', client.getNews);
    benchmark.results.last.addAll(size(news));

    final data = await benchmark.measure('authors, songs, songbooks, tags and ids of song lyrics', client.getData);
    benchmark.results.last.addAll(size(data));

    final songLyrics = await benchmark.measure(
      'song lyrics updated in last 30 days',
      () => client.getSongLyrics(updatedAfter),
    );
    benchmark.results.last.addAll({...size(songLyrics), 'count': (songLyrics['song_lyrics'] as List).length});

    final svgs = await benchmark.measure('svgs updated in last 30 days', () => client.getSvgs(updatedAfter));
    benchmark.results.last.addAll({'bytes': svgs.length});
  });
}
