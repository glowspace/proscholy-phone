import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/components/song_lyric/song_lyric_row.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/search.dart';
import 'package:proscholy_common/screens/display.dart';
import 'package:proscholy_common/screens/search.dart';

import '../utils.dart';

void main() {
  setUpAll(mockFirebase);

  Future<AppDependencies> pumpSearch(WidgetTester tester) async {
    final appDependencies = (await tester.runAsync(() async {
      final appDependencies = await createAppDependencies();

      await storeTestData(appDependencies);

      return appDependencies;
    }))!;

    await pumpApp(tester, appDependencies, route: '/search');

    return appDependencies;
  }

  Future<void> search(WidgetTester tester, String text) async {
    await tester.enterText(
      find.descendant(of: find.byKey(const Key('searchfield')), matching: find.byType(TextField)),
      text,
    );
  }

  Finder findSongLyricRow(int id) {
    return find.byWidgetPredicate((widget) => widget is SongLyricRow && widget.songLyric.id == id);
  }

  testWidgets('shows song lyrics matching searched text and opens them', (tester) async {
    final appDependencies = await pumpSearch(tester);

    await search(tester, 'Bože chválí');
    await pumpUntil(tester, () => findSongLyricRow(1).evaluate().isEmpty && findSongLyricRow(2).evaluate().isNotEmpty);

    expect(find.byType(SongLyricRow), findsOneWidget);
    expect(findSongLyricRow(2), findsOneWidget);

    await tester.tap(findSongLyricRow(2));
    await tester.pumpAndSettle();

    expect(find.byType(DisplayScreen), findsOneWidget);
    expect(find.text(appDependencies.store.box<SongLyric>().get(2)!.displayName), findsOneWidget);
  });

  testWidgets('opens song lyric matched by number after submitting', (tester) async {
    await pumpSearch(tester);

    // ZPS matches song lyric by its id, EZ and EK by number in their songbook
    final number = isZPS ? '1' : (isEZ ? '12' : '7A');
    final container = ProviderScope.containerOf(tester.element(find.byType(SearchScreen)));

    await search(tester, number);
    await pumpUntil(tester, () => container.read(searchedSongLyricsProvider).searchedNumber == number);

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect((tester.widget(find.byType(DisplayScreen)) as DisplayScreen).items.single.id, 1);
  });
}
