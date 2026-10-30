import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/components/home/update_section.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/update.dart';

import '../../utils.dart';

void main() {
  var updates = 0;

  setUp(() => updates = 0);

  Future<void> pumpUpdateSection(
    WidgetTester tester,
    Stream<UpdateStatus> update, {
    Widget body = const UpdateSection(),
  }) async {
    final appDependencies = await tester.runAsync(createAppDependencies);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDependenciesProvider.overrideWithValue(appDependencies!),
          updateProvider.overrideWith((_) {
            updates++;
            return update;
          }),
        ],
        // disable automatic retry, so that no retry timer is left pending after test
        retry: (_, _) => null,
        child: MaterialApp(home: Scaffold(body: body)),
      ),
    );
    await tester.pump();
  }

  bool isShowing(WidgetTester tester) {
    // closed section has no height, so it is offstage
    final crossFade = tester.widget<AnimatedCrossFade>(find.byType(AnimatedCrossFade, skipOffstage: false));

    return crossFade.crossFadeState == CrossFadeState.showFirst;
  }

  testWidgets('shows progress during update', (tester) async {
    await pumpUpdateSection(tester, Stream.value(const Updating()));

    expect(isShowing(tester), isTrue);
    expect(find.text('Probíhá stahování písní'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('shows number of updated song lyrics', (tester) async {
    final songLyrics = [createSongLyric(id: 1, lyrics: 'text'), createSongLyric(id: 2, lyrics: 'text')];

    await pumpUpdateSection(tester, Stream.value(Updated(songLyrics)));

    expect(isShowing(tester), isTrue);
    expect(find.text('Počet aktualizovaných písní: 2'), findsOneWidget);
    expect(find.text('Zobrazit'), findsOneWidget);
  });

  testWidgets('is hidden when nothing was updated', (tester) async {
    await pumpUpdateSection(tester, Stream.value(const Updated([])));

    expect(isShowing(tester), isFalse);
  });

  testWidgets('is hidden when update was interrupted', (tester) async {
    await pumpUpdateSection(tester, Stream.value(const UpdateInterrupted()));

    expect(isShowing(tester), isFalse);
  });

  testWidgets('shows error with option to report it', (tester) async {
    await pumpUpdateSection(tester, Stream.error(Exception('Server Error')));

    expect(isShowing(tester), isTrue);
    expect(find.text('Při aktualizaci nastala chyba'), findsOneWidget);
    expect(find.text('Nahlásit chybu'), findsOneWidget);
  });

  testWidgets('can be closed', (tester) async {
    await pumpUpdateSection(tester, Stream.error(Exception('Server Error')));
    // wait until section is fully shown
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    expect(isShowing(tester), isFalse);
  });

  // on phones sections of home are in a lazy list, which disposes the ones that are scrolled away
  testWidgets('keeps update and its closing, when scrolled away', (tester) async {
    await pumpUpdateSection(
      tester,
      Stream.value(Updated([createSongLyric(id: 1, lyrics: 'text')])),
      body: CustomScrollView(
        slivers: [
          SliverList.list(children: const [UpdateSection(), SizedBox(height: 2000)]),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1500));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(CustomScrollView), const Offset(0, 1500));
    await tester.pumpAndSettle();

    expect(updates, 1);
    expect(isShowing(tester), isFalse);
  });
}
