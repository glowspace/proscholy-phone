import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/tag.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/tags.dart';
import 'package:proscholy_common/routing/navigation_rail_wrapper.dart';
import 'package:proscholy_common/routing/router.dart';
import 'package:proscholy_common/screens/display.dart';
import 'package:proscholy_common/screens/home.dart';
import 'package:proscholy_common/screens/songbook.dart';
import 'package:proscholy_common/screens/songbooks.dart';
import 'package:proscholy_common/utils/data.dart';
import 'package:proscholy_common/utils/extensions.dart';

import '../utils.dart';

void main() {
  late BuildContext context;

  Future<void> pumpProviderScope(WidgetTester tester) async {
    final appDependencies = await tester.runAsync(() async {
      final appDependencies = await createAppDependencies();
      final data = readTestData();

      await parseAndStoreData(appDependencies.store, data);
      await storeSongLyrics(appDependencies.store, readJsonList(data[SongLyric.fieldKey], mapper: SongLyric.fromJson));

      return appDependencies;
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDependenciesProvider.overrideWithValue(appDependencies!)],
        child: Builder(
          builder: (buildContext) {
            context = buildContext;

            return const SizedBox();
          },
        ),
      ),
    );
  }

  List<String?> initialRoutes(String initialRoute) {
    return [for (final route in AppRouter.generateInitialRoutes(initialRoute)) route.settings.name];
  }

  MaterialPageRoute route(String name) => AppRouter.generateRoute(RouteSettings(name: name)) as MaterialPageRoute;

  Widget screen(String name) => (route(name).builder(context) as NavigationRailWrapper).builder(context);

  testWidgets('song lyric links', (tester) async {
    await pumpProviderScope(tester);

    expect((screen('/pisen/1/at-srdce-me-tebe-vida') as DisplayScreen).items.single.id, 1);
    expect((screen('/song_lyric?id=2') as DisplayScreen).items.single.id, 2);
  });

  testWidgets('songbook links', (tester) async {
    await pumpProviderScope(tester);

    expect((screen('/zpevnik/9/chvalozpevy-3') as SongbookScreen).songbook.id, 9);
    expect(screen('/zpevniky'), isA<SongbooksScreen>());
  });

  testWidgets('search links', (tester) async {
    await pumpProviderScope(tester);

    expect(route('/hledani?text=srdce').settings.name, '/search');
    expect(route('/hledani?text=srdce').fullscreenDialog, isTrue);
    expect(route('/hledani').settings.name, '/');
  });

  // filters are only in ZPS
  testWidgets('search links skip unknown tags and songbooks', skip: !isZPS, (tester) async {
    await pumpProviderScope(tester);

    // tags are selected after the first frame
    screen('/hledani?stitky=16,999,abc&zpevniky=9,999,abc');
    tester.binding.scheduleFrame();
    await tester.pump();

    expect(
      context.providers.read(selectedTagsProvider).map((tag) => tag.id),
      unorderedEquals([16, kSongbookTagIdOffset - 9]),
    );
  });

  testWidgets('link to missing song lyric or songbook opens home', (tester) async {
    await pumpProviderScope(tester);

    // arrangements are not stored
    expect(screen('/pisen/3/aranzma'), isA<HomeScreen>());
    expect(screen('/song_lyric?id=999'), isA<HomeScreen>());
    expect(screen('/zpevnik/999/neznamy'), isA<HomeScreen>());
  });

  testWidgets('invalid link opens home', (tester) async {
    await pumpProviderScope(tester);

    expect(screen('/pisen/'), isA<HomeScreen>());
    expect(screen('/pisen/abc'), isA<HomeScreen>());
    expect(screen('/song_lyric?id=abc'), isA<HomeScreen>());
    expect(screen('/zpevnik/abc'), isA<HomeScreen>());
  });

  testWidgets('unknown link opens home', (tester) async {
    await pumpProviderScope(tester);

    expect(screen('/neznama/stranka'), isA<HomeScreen>());
  });

  test('initial routes', () {
    expect(initialRoutes('/'), ['/']);
    expect(initialRoutes('/song_lyric?id=1'), ['/', '/song_lyric?id=1']);
    expect(initialRoutes('https://zpevnik.proscholy.cz/pisen/1/at-srdce'), [
      '/',
      'https://zpevnik.proscholy.cz/pisen/1/at-srdce',
    ]);
  });

  // opened files are handled by `ExternalActionsService`, but their uri is also used as initial route
  test('initial routes of opened files', () {
    expect(initialRoutes('content://com.microsoft.office.outlook.fileprovider/attachment/hodina.docx'), ['/']);
    expect(initialRoutes('file:///storage/emulated/0/Download/Mše.proscholy'), ['/']);
  });
}
