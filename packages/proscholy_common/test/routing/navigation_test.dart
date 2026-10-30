import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/components/song_lyric/song_lyric_row.dart';
import 'package:proscholy_common/components/song_lyric/song_lyric_tag.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/playlist_record.dart';
import 'package:proscholy_common/models/tag.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/tags.dart';
import 'package:proscholy_common/screens/display.dart';
import 'package:proscholy_common/screens/home.dart';
import 'package:proscholy_common/screens/playlist.dart';
import 'package:proscholy_common/screens/playlists.dart';
import 'package:proscholy_common/screens/search.dart';
import 'package:proscholy_common/screens/songbook.dart';
import 'package:proscholy_common/utils/services/external_actions.dart';
import 'package:proscholy_common/views/tag.dart';

import '../utils.dart';

void main() {
  setUpAll(mockFirebase);

  Future<void> pumpNavigation(WidgetTester tester, {String route = '/'}) async {
    final appDependencies = (await tester.runAsync(() async {
      final appDependencies = await createAppDependencies();

      await storeTestData(appDependencies);

      appDependencies.store.box<Playlist>().put(Playlist(id: 2, name: 'Mše', rank: 0, records: ToMany()));
      appDependencies.store.box<PlaylistRecord>().put(
        PlaylistRecord(
          id: 1,
          rank: 0,
          songLyric: ToOne(targetId: 1),
          userText: ToOne(),
          biblePassage: ToOne(),
          playlist: ToOne(targetId: 2),
        ),
      );

      return appDependencies;
    }))!;

    await pumpApp(tester, appDependencies, route: route);
  }

  Future<void> tapDestination(WidgetTester tester, String label) async {
    await tester.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text(label)).last);
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  Future<void> goBack(WidgetTester tester) async {
    await ExternalActionsService.instance.navigatorKey.currentState!.maybePop();
    await tester.pumpAndSettle();
  }

  // screens of all routes in navigator, including the covered ones
  Finder findInStack(Type type) => find.byType(type, skipOffstage: false);

  ProviderContainer container(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.byType(MaterialApp)));

  Set<String> selectedTagNames(WidgetTester tester) {
    return {for (final tag in container(tester).read(selectedTagsProvider)) tag.name};
  }

  Future<String> selectTag(WidgetTester tester) async {
    final tag = container(
      tester,
    ).read(appDependenciesProvider).store.box<Tag>().getAll().firstWhere((tag) => tag.isSupported);

    container(tester).read(selectedTagsProvider.notifier).toggleSelection(tag);
    await tester.pumpAndSettle();

    return tag.name;
  }

  testWidgets('search destination does not open search again', (tester) async {
    await pumpNavigation(tester);

    await tapDestination(tester, 'Hledání');
    await tapDestination(tester, 'Hledání');

    expect(findInStack(SearchScreen), findsOneWidget);
  });

  testWidgets('destinations go back to their screens that are already open', (tester) async {
    await pumpNavigation(tester);

    await tapDestination(tester, 'Hledání');
    await tapDestination(tester, 'Seznamy');
    await tapText(tester, 'Mše');
    await tapDestination(tester, 'Seznamy');

    expect(find.byType(PlaylistsScreen), findsOneWidget);
    expect(findInStack(PlaylistsScreen), findsOneWidget);
    expect(findInStack(PlaylistScreen), findsNothing);

    await tapDestination(tester, 'Hledání');

    expect(find.byType(SearchScreen), findsOneWidget);
    expect(findInStack(SearchScreen), findsOneWidget);
    expect(findInStack(PlaylistsScreen), findsNothing);
  });

  testWidgets('search in playlist opens new search and restores tags of previous one', (tester) async {
    await pumpNavigation(tester);

    await tapDestination(tester, 'Hledání');
    await tapDestination(tester, 'Seznamy');
    await tapText(tester, 'Mše');
    await tester.tap(find.byIcon(Icons.filter_alt));
    await tester.pumpAndSettle();

    expect(findInStack(SearchScreen), findsNWidgets(2));
    expect(findInStack(PlaylistScreen), findsOneWidget);
    expect(selectedTagNames(tester), {'Mše'});

    await goBack(tester);

    expect(find.byType(PlaylistScreen), findsOneWidget);
    expect(selectedTagNames(tester), isEmpty);
  }, skip: !isZPS);

  testWidgets('playlist has filter only where tags are supported', (tester) async {
    await pumpNavigation(tester);

    await tapDestination(tester, 'Seznamy');
    await tapText(tester, 'Mše');

    expect(find.byIcon(Icons.filter_alt), isZPS ? findsOneWidget : findsNothing);
  });

  testWidgets('song lyric for playlist is picked in new search', (tester) async {
    await pumpNavigation(tester);

    await tapDestination(tester, 'Hledání');
    // EZ and EK have no tags to filter by
    final tagName = isZPS ? await selectTag(tester) : null;
    await tapDestination(tester, 'Seznamy');
    await tapText(tester, 'Mše');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tapText(tester, 'píseň');

    expect(findInStack(SearchScreen), findsNWidgets(2));
    expect(findInStack(PlaylistScreen), findsOneWidget);
    expect(selectedTagNames(tester), isEmpty);

    await pumpUntil(tester, () => find.byType(SongLyricRow).evaluate().isNotEmpty);
    await tester.tap(find.byType(SongLyricRow).first);
    await tester.pumpAndSettle();

    expect(find.byType(PlaylistScreen), findsOneWidget);
    expect(findInStack(SearchScreen), findsOneWidget);
    expect(selectedTagNames(tester), {?tagName});
  });

  testWidgets('song lyric opened from tag search keeps previous screens', (tester) async {
    await pumpNavigation(tester);

    // songbook chips in sheet with tags don't fit on smaller phone in test font
    tester.view.physicalSize = const Size(1290, 2796);
    await tester.pumpAndSettle();

    await tapDestination(tester, 'Hledání');
    final songLyricRow = find.byWidgetPredicate((widget) => widget is SongLyricRow && widget.songLyric.id == 1);
    await pumpUntil(tester, () => songLyricRow.evaluate().isNotEmpty);
    await tester.tap(songLyricRow.first);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Štítky').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SongLyricTag).first);
    await tester.pumpAndSettle();
    await pumpUntil(tester, () => find.byType(SongLyricRow).evaluate().isNotEmpty);
    await tester.tap(find.byType(SongLyricRow).first);
    await tester.pumpAndSettle();

    expect(findInStack(DisplayScreen), findsNWidgets(2));
    expect(findInStack(SearchScreen), findsNWidgets(2));

    await goBack(tester);

    expect(find.byType(SearchScreen), findsOneWidget);
    expect(findInStack(DisplayScreen), findsOneWidget);
  }, skip: !isZPS);

  testWidgets('home destination closes all screens', (tester) async {
    await pumpNavigation(tester);

    await tapDestination(tester, 'Hledání');
    await tapDestination(tester, 'Seznamy');
    await tapText(tester, 'Mše');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tapText(tester, 'píseň');
    await tapDestination(tester, 'Nástěnka');

    expect(findInStack(SearchScreen), findsNothing);
    expect(findInStack(PlaylistsScreen), findsNothing);
    expect(findInStack(PlaylistScreen), findsNothing);
    expect(selectedTagNames(tester), isEmpty);
  });

  testWidgets('link opens its screen above home', (tester) async {
    final handlesBack = <bool>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'SystemNavigator.setFrameworkHandlesBack') handlesBack.add(call.arguments as bool);

      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
    // app tells Android whether it handles back only when it has lifecycle state
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

    await pumpNavigation(tester, route: 'https://zpevnik.proscholy.cz/zpevnik/9/chvalozpevy-3');

    expect(find.byType(SongbookScreen), findsOneWidget);
    expect(findInStack(HomeScreen), findsOneWidget);
    // otherwise back on Android closes the app instead of going home
    expect(handlesBack.last, isTrue);
  });

  // opened files are handled by `ExternalActionsService`, but their uri is also used as initial route
  testWidgets('opened file opens only home', (tester) async {
    await pumpNavigation(tester, route: 'content://com.microsoft.office.outlook.fileprovider/attachment/hodina.docx');

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(ExternalActionsService.instance.navigatorKey.currentState!.canPop(), isFalse);
  });

  // Android starts the gesture with the linked screen fully shown, so heroes measure home right away
  testWidgets('back gesture on screen opened by link', (tester) async {
    await pumpNavigation(tester, route: '/zpevnik/9/chvalozpevy-3');

    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      SystemChannels.backGesture.name,
      SystemChannels.backGesture.codec.encodeMethodCall(
        const MethodCall('startBackGesture', {
          'touchOffset': [5.0, 300.0],
          'progress': 0.0,
          'swipeEdge': 0,
        }),
      ),
      (_) {},
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
