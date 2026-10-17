// benchmarks of screens with data of the app, `../<app>/assets/data.json` is used as data
// they run in test environment, so only building, layout and painting are measured, without GPU
// flutter test benchmark/screens_benchmark_test.dart --dart-define=ZPEVNIK_TARGET=ZPS
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/providers/search.dart';
import 'package:proscholy_common/screens/search.dart';
import 'package:proscholy_common/utils/data.dart';

import '../test/utils.dart';
import 'utils.dart';

void main() {
  final benchmark = Benchmark('screens');

  setUpAll(mockFirebase);
  tearDownAll(benchmark.save);

  testWidgets('screens with data of the app', (tester) async {
    final (appDependencies, longestSongLyric) = (await tester.runAsync(() async {
      final appDependencies = await createAppDependencies();
      final data = jsonDecode(appDataFile.readAsStringSync())['data'];

      await parseAndStoreData(appDependencies.store, data);

      final songLyrics = await storeSongLyrics(
        appDependencies.store,
        readJsonList(data[SongLyric.fieldKey], mapper: SongLyric.fromJson),
      );

      await SearchedSongLyrics.update(appDependencies.ftsDatabase, songLyrics);

      final longestSongLyric = songLyrics.reduce(
        (a, b) => (a.lyrics?.length ?? 0) >= (b.lyrics?.length ?? 0) ? a : b,
      );

      return (appDependencies, longestSongLyric);
    }))!;

    await benchmark.measure('open home', () => pumpApp(tester, appDependencies));

    // navigator uses initial route only when it is created
    await tester.pumpWidget(const SizedBox());

    await benchmark.measure(
      'open search with all song lyrics',
      () => pumpApp(tester, appDependencies, route: '/search'),
    );

    final container = ProviderScope.containerOf(tester.element(find.byType(SearchScreen)));

    await benchmark.measure('search "pane" until results are shown', () async {
      await tester.enterText(
        find.descendant(of: find.byKey(const Key('searchfield')), matching: find.byType(TextField)),
        'pane',
      );
      await pumpUntil(tester, () => container.read(searchedSongLyricsProvider).songLyrics != null);
      await tester.pump();
    });

    await benchmark.measure('scroll search results', () async {
      await tester.fling(find.byType(Scrollable).last, const Offset(0, -5000), 5000);
      await tester.pumpAndSettle();
    });

    await tester.pumpWidget(const SizedBox());

    await benchmark.measure(
      'open longest song lyric',
      () => pumpApp(tester, appDependencies, route: '/song_lyric?id=${longestSongLyric.id}'),
      info: {'characters': longestSongLyric.lyrics?.length ?? 0},
    );

    await benchmark.measure('scroll longest song lyric', () async {
      await tester.fling(find.byType(Scrollable).last, const Offset(0, -5000), 5000);
      await tester.pumpAndSettle();
    });
  });
}
