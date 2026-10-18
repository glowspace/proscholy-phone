import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/components/playlist/playlist_button.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/playlist_record.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/user_text.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/screens/playlist.dart';

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

  Future<void> openPlaylistMenu(WidgetTester tester, String action) async {
    await tester.tap(find.text('Mše'));
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(of: find.byType(AppBar), matching: find.byType(PlaylistButton)));
    await tester.pumpAndSettle();

    await tester.tap(find.text(action));
    await tester.pumpAndSettle();
  }

  testWidgets('renaming open playlist changes its title', (tester) async {
    await pumpPlaylists(tester);
    await openPlaylistMenu(tester, 'Přejmenovat');

    await tester.enterText(find.descendant(of: find.byType(Dialog), matching: find.byType(TextField)), 'Adorace');
    await tester.tap(find.text('Přejmenovat'));
    await tester.pumpAndSettle();

    // changes in store are notified asynchronously
    final title = find.descendant(of: find.byType(AppBar), matching: find.text('Adorace'));
    await pumpUntil(tester, () => title.evaluate().isNotEmpty);

    expect(title, findsOneWidget);
  });

  testWidgets('records removed from store are removed from open playlist', (tester) async {
    final appDependencies = await pumpPlaylists(tester);
    final store = appDependencies.store;
    final names = [
      for (final id in [1, 2]) store.box<SongLyric>().get(id)!.name,
    ];

    store.box<PlaylistRecord>().putMany([
      for (final id in [1, 2])
        PlaylistRecord(
          id: id,
          rank: id,
          songLyric: ToOne(targetId: id),
          userText: ToOne(),
          biblePassage: ToOne(),
          playlist: ToOne(targetId: 2),
        ),
    ]);

    await tester.tap(find.text('Mše'));
    await tester.pumpAndSettle();

    expect(find.text(names[1]), findsOneWidget);

    // e.g. update removes records of song lyrics that are not on server
    store.box<PlaylistRecord>().remove(2);

    await pumpUntil(tester, () => find.text(names[1]).evaluate().isEmpty);

    expect(find.text(names[0]), findsOneWidget);
    expect(find.text(names[1]), findsNothing);
  });

  testWidgets('removing open playlist removes its texts and returns to playlists', (tester) async {
    final appDependencies = await pumpPlaylists(tester);
    final store = appDependencies.store;

    store.box<UserText>().put(const UserText(id: 1, name: 'Ohlášky', content: 'text'));
    store.box<PlaylistRecord>().put(
      PlaylistRecord(
        id: 1,
        rank: 0,
        songLyric: ToOne(),
        userText: ToOne(targetId: 1),
        biblePassage: ToOne(),
        playlist: ToOne(targetId: 2),
      ),
    );

    await openPlaylistMenu(tester, 'Odstranit');

    await tester.tap(find.text('Smazat'));
    await tester.pumpAndSettle();

    expect(find.byType(PlaylistScreen), findsNothing);
    expect(find.text('Mše'), findsNothing);
    expect(store.box<Playlist>().get(2), isNull);
    expect(store.box<UserText>().isEmpty(), isTrue);
  });
}
