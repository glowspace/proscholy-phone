import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';

import '../utils.dart';

void main() {
  setUpAll(mockFirebase);

  Future<AppDependencies> pumpPlaylists(WidgetTester tester) async {
    final appDependencies = (await tester.runAsync(() async {
      final appDependencies = await createAppDependencies();

      await storeTestData(appDependencies);

      appDependencies.store.box<Playlist>().put(Playlist(id: 2, name: 'Mše', rank: 0, records: ToMany()));

      return appDependencies;
    }))!;

    await pumpApp(tester, appDependencies, route: '/playlists');

    return appDependencies;
  }

  Future<void> createPlaylist(WidgetTester tester, String name) async {
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.descendant(of: find.byType(Dialog), matching: find.byType(TextField)), name);
    await tester.tap(find.text('Vytvořit'));
    await tester.pumpAndSettle();
  }

  testWidgets('creates playlist', (tester) async {
    final appDependencies = await pumpPlaylists(tester);

    await createPlaylist(tester, 'Adorace');

    expect(find.byType(Dialog), findsNothing);
    expect(find.text('Adorace'), findsOneWidget);
    expect(appDependencies.store.box<Playlist>().getAll().map((playlist) => playlist.name), contains('Adorace'));
  });

  testWidgets('does not create playlist with existing name', (tester) async {
    final appDependencies = await pumpPlaylists(tester);

    await createPlaylist(tester, 'Mše');

    expect(find.text('Playlist s tímto názvem již existuje'), findsOneWidget);
    expect(appDependencies.store.box<Playlist>().getAll().where((playlist) => playlist.name == 'Mše'), hasLength(1));
  });
}
