import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/components/home/update_section.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/update.dart';

import '../../utils.dart';

void main() {
  Future<void> pumpUpdateSection(WidgetTester tester, Stream<UpdateStatus> update) async {
    final appDependencies = await tester.runAsync(createAppDependencies);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDependenciesProvider.overrideWithValue(appDependencies!),
          updateProvider.overrideWith((_) => update),
        ],
        // disable automatic retry, so that no retry timer is left pending after test
        retry: (_, _) => null,
        child: const MaterialApp(home: Scaffold(body: UpdateSection())),
      ),
    );
    await tester.pump();
  }

  bool isShowing(WidgetTester tester) {
    return tester.widget<AnimatedCrossFade>(find.byType(AnimatedCrossFade)).crossFadeState == CrossFadeState.showFirst;
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
}
