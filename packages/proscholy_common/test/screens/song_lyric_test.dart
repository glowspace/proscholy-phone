import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/playlist_record.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';

import '../utils.dart';

void main() {
  setUpAll(mockFirebase);

  Future<AppDependencies> pumpSongLyric(WidgetTester tester) async {
    final appDependencies = (await tester.runAsync(() async {
      final appDependencies = await createAppDependencies();

      await storeTestData(appDependencies);

      return appDependencies;
    }))!;

    await pumpApp(tester, appDependencies, route: '/song_lyric?id=1');

    return appDependencies;
  }

  testWidgets('shows lyrics with chords', (tester) async {
    final appDependencies = await pumpSongLyric(tester);

    // EZ and EK take name from their songbooks
    expect(find.text(appDependencies.store.box<SongLyric>().get(1)!.displayName), findsOneWidget);
    expect(find.textContaining('srdce mé tebe zná', findRichText: true), findsOneWidget);
    expect(find.text('Dmaj7', findRichText: true), findsOneWidget);
  });

  testWidgets('transposes chords', (tester) async {
    await pumpSongLyric(tester);

    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Emaj7', findRichText: true), findsOneWidget);
    expect(find.text('Dmaj7', findRichText: true), findsNothing);
  });

  testWidgets('adds song lyric to favorites', (tester) async {
    final appDependencies = await pumpSongLyric(tester);

    await tester.tap(find.byIcon(Icons.star_outline));
    await tester.pump();

    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(appDependencies.store.box<PlaylistRecord>().getAll().map((record) => record.songLyric.targetId), [1]);
  });
}
