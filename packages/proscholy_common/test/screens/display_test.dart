import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/components/playlist/bible_passage.dart';
import 'package:proscholy_common/components/selected_displayable_item_arguments.dart';
import 'package:proscholy_common/models/bible_passage.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/display_screen_status.dart';
import 'package:proscholy_common/providers/presentation.dart';
import 'package:proscholy_common/providers/svgs.dart';
import 'package:proscholy_common/routing/arguments.dart';
import 'package:proscholy_common/screens/display.dart';
import 'package:proscholy_common/utils/data.dart';
import 'package:proscholy_common/utils/services/external_actions.dart';

import '../utils.dart';

class _FakeSvgs extends Svgs {
  @override
  Map<String, FileSystemEntity> build() => {};
}

void main() {
  setUpAll(mockFirebase);

  // tablet shows list of items next to display screen and both share selected item
  Future<(List<SongLyric>, ValueNotifier<DisplayScreenArguments>, Future<void> Function(Widget))> setUpTablet(
    WidgetTester tester,
  ) async {
    final (appDependencies, songLyrics) = (await tester.runAsync(() async {
      final appDependencies = await createAppDependencies();
      final data = readTestData();

      await parseAndStoreData(appDependencies.store, data);

      final songLyrics = await storeSongLyrics(
        appDependencies.store,
        readJsonList(data[SongLyric.fieldKey], mapper: SongLyric.fromJson),
      );

      return (appDependencies, songLyrics);
    }))!;

    final selectedNotifier = ValueNotifier(DisplayScreenArguments(items: songLyrics));

    Future<void> pumpTablet(Widget child) {
      return tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDependenciesProvider.overrideWithValue(appDependencies),
            svgsProvider.overrideWith(_FakeSvgs.new),
          ],
          retry: (_, _) => null,
          child: MaterialApp(
            home: SelectedDisplayableItemArguments(displayableItemArgumentsNotifier: selectedNotifier, child: child),
          ),
        ),
      );
    }

    return (songLyrics, selectedNotifier, pumpTablet);
  }

  testWidgets('shows newly selected items at once', (tester) async {
    final (songLyrics, selectedNotifier, pumpTablet) = await setUpTablet(tester);

    await pumpTablet(DisplayScreen(items: songLyrics));
    await tester.pump(const Duration(seconds: 1));

    selectedNotifier.value = DisplayScreenArguments(items: [songLyrics[1]]);
    await tester.pump();

    expect(find.text(songLyrics[1].displayName), findsOneWidget);
    expect(find.text(songLyrics[0].displayName), findsNothing);

    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('closed display screen does not react to change of selected item', (tester) async {
    final (songLyrics, selectedNotifier, pumpTablet) = await setUpTablet(tester);

    await pumpTablet(DisplayScreen(items: songLyrics));
    await tester.pump(const Duration(seconds: 1));

    // display screen is closed
    await pumpTablet(const SizedBox());

    selectedNotifier.value = DisplayScreenArguments(items: songLyrics, initialIndex: 1);
    await tester.pump(const Duration(seconds: 1));
  });

  group('bottom space of items', () {
    final biblePassage = BiblePassage(
      book: 0,
      chapter: 1,
      startVerse: 1,
      text: List.generate(100, (verse) => '${verse + 1} Na počátku stvořil Bůh nebe a zemi.').join('\n'),
    );

    Future<ProviderContainer> pumpBiblePassage(WidgetTester tester) async {
      final appDependencies = (await tester.runAsync(() async {
        final appDependencies = await createAppDependencies();

        await storeTestData(appDependencies);

        return appDependencies;
      }))!;

      await pumpApp(tester, appDependencies);

      // presentation runs on external display, so the passage stays on the phone
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('proscholyCommon/presentation'),
        (call) async => call.method == 'isExternalScreenConnected' ? true : null,
      );

      ExternalActionsService.instance.navigatorKey.currentState!.pushNamed(
        '/display',
        arguments: DisplayScreenArguments(items: [biblePassage]),
      );
      await tester.pumpAndSettle();

      return ProviderScope.containerOf(tester.element(find.byType(DisplayScreen)));
    }

    testWidgets('covers bottom sheet and system navigation bar in full screen', (tester) async {
      final container = await pumpBiblePassage(tester);

      tester.view.padding = const FakeViewPadding(bottom: 144);
      tester.view.viewPadding = const FakeViewPadding(bottom: 144);
      await tester.pumpAndSettle();

      double bottomPadding() => MediaQuery.paddingOf(tester.element(find.byType(BiblePassageWidget))).bottom;

      // bottom bar is below the items
      expect(bottomPadding(), 0);

      container.read(presentationProvider).start();
      await tester.pumpAndSettle();

      expect(bottomPadding(), tester.getSize(find.byType(BottomSheet)).height);

      container.read(displayScreenStatusProvider.notifier).toggleFullScreen();
      await tester.pumpAndSettle();

      // bottom sheet is above system navigation bar
      expect(bottomPadding(), tester.getSize(find.byType(BottomSheet)).height);
      expect(bottomPadding(), greaterThan(48));
    });

    testWidgets('keeps end of bible passage above presentation controls', (tester) async {
      final container = await pumpBiblePassage(tester);

      container.read(presentationProvider).start();
      await tester.pumpAndSettle();

      final scrollPosition = tester
          .state<ScrollableState>(
            find.descendant(of: find.byType(BiblePassageWidget), matching: find.byType(Scrollable)),
          )
          .position;
      scrollPosition.jumpTo(scrollPosition.maxScrollExtent);
      await tester.pumpAndSettle();

      expect(
        tester.getBottomLeft(find.textContaining('CrossWire')).dy,
        lessThanOrEqualTo(tester.getTopLeft(find.byType(BottomSheet)).dy),
      );
    });
  });
}
