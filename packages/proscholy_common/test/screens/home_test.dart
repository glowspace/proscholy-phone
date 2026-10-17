import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/news_item.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/home.dart';
import 'package:proscholy_common/screens/songbook.dart';

import '../utils.dart';

void main() {
  setUpAll(mockFirebase);

  // EZ and EK show only recent items by default
  Future<AppDependencies> createAppDependenciesWithData(WidgetTester tester, List<HomeSection> homeSections) async {
    return (await tester.runAsync(() async {
      final appDependencies = await createAppDependencies(
        preferences: {
          'home_screen_sections': [for (final homeSection in homeSections) '${homeSection.index}'],
        },
      );

      await storeTestData(appDependencies);

      return appDependencies;
    }))!;
  }

  testWidgets('opens songbook', (tester) async {
    final appDependencies = await createAppDependenciesWithData(tester, [HomeSection.songbooks]);

    await pumpApp(tester, appDependencies);

    await tester.tap(find.text('Chvalozpěvy 3'));
    await tester.pumpAndSettle();

    expect(find.byType(SongbookScreen), findsOneWidget);
    expect(find.text(appDependencies.store.box<SongLyric>().get(1)!.displayName), findsOneWidget);
  });

  testWidgets('shows only news that did not expire', (tester) async {
    final appDependencies = await createAppDependenciesWithData(tester, [HomeSection.news]);
    final now = DateTime.now();

    appDependencies.store.box<NewsItem>().putMany([
      NewsItem(id: 1, text: 'Nová verze', link: '', expiresAt: now.add(const Duration(days: 1))),
      NewsItem(id: 2, text: 'Stará verze', link: '', expiresAt: now.subtract(const Duration(days: 1))),
    ]);

    await pumpApp(tester, appDependencies);

    expect(find.text('Nová verze'), findsOneWidget);
    expect(find.text('Stará verze'), findsNothing);
  });

  testWidgets('long news text does not overflow', (tester) async {
    final appDependencies = await createAppDependenciesWithData(tester, [HomeSection.news]);

    appDependencies.store.box<NewsItem>().put(
      NewsItem(
        id: 1,
        text: 'Vyšla nová verze zpěvníku s mnoha novými písněmi',
        link: '/novinky',
        expiresAt: DateTime.now().add(const Duration(days: 1)),
      ),
    );

    await pumpApp(tester, appDependencies);

    expect(find.textContaining('Vyšla nová verze'), findsOneWidget);
  });
}
