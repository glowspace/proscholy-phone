import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/components/playlist/playlist_record_row.dart';
import 'package:proscholy_common/components/playlist/playlist_records_list_view.dart';
import 'package:proscholy_common/components/selected_displayable_item_arguments.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/playlist_record.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/routing/arguments.dart';
import 'package:proscholy_common/utils/data.dart';

import '../../utils.dart';

PlaylistRecord _record(int id, int songLyricId) {
  return PlaylistRecord(
    id: id,
    rank: id,
    songLyric: ToOne(targetId: songLyricId),
    userText: ToOne(),
    biblePassage: ToOne(),
    playlist: ToOne(targetId: 2),
  );
}

void main() {
  late ValueNotifier<bool> sortedAlphabeticallyNotifier;

  // tablet shows display screen next to playlist and both share selected item
  Future<Store> pumpPlaylist(WidgetTester tester, {ValueNotifier<DisplayScreenArguments>? selectedNotifier}) async {
    final (appDependencies, playlist) = (await tester.runAsync(() async {
      final appDependencies = await createAppDependencies();
      final store = appDependencies.store;
      final data = readTestData();

      await parseAndStoreData(store, data);
      await storeSongLyrics(store, readJsonList(data[SongLyric.fieldKey], mapper: SongLyric.fromJson));

      store.box<Playlist>().put(Playlist(id: 2, name: 'Mše', rank: 0, records: ToMany()));
      // song lyric 999 is not downloaded, which might happen with received playlists
      store.box<PlaylistRecord>().putMany([_record(1, 2), _record(2, 999), _record(3, 1)]);

      return (appDependencies, store.box<Playlist>().get(2)!);
    }))!;

    sortedAlphabeticallyNotifier = ValueNotifier(false);

    final listView = PlaylistRecordsListView(
      playlist: playlist,
      sortedAlphabeticallyNotifier: sortedAlphabeticallyNotifier,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDependenciesProvider.overrideWithValue(appDependencies)],
        child: MaterialApp(
          home: Scaffold(
            body: selectedNotifier == null
                ? listView
                : SelectedDisplayableItemArguments(displayableItemArgumentsNotifier: selectedNotifier, child: listView),
          ),
        ),
      ),
    );

    return appDependencies.store;
  }

  List<String> shownNames(WidgetTester tester) {
    return [
      for (final row in tester.widgetList<PlaylistRecordRow>(find.byType(PlaylistRecordRow)))
        row.playlistRecord.songLyric.target!.name,
    ];
  }

  testWidgets('records of missing song lyrics are not shown', (tester) async {
    await pumpPlaylist(tester);

    expect(shownNames(tester), ['Bože, chválí tebe', 'Ať srdce mé tebe vídá']);
  });

  testWidgets('sorting alphabetically', (tester) async {
    await pumpPlaylist(tester);

    sortedAlphabeticallyNotifier.value = true;
    await tester.pump();

    expect(shownNames(tester), ['Ať srdce mé tebe vídá', 'Bože, chválí tebe']);

    sortedAlphabeticallyNotifier.value = false;
    await tester.pump();

    expect(shownNames(tester), ['Bože, chválí tebe', 'Ať srdce mé tebe vídá']);
  });

  testWidgets('removing record', (tester) async {
    await pumpPlaylist(tester);

    await tester.drag(find.byType(PlaylistRecordRow).last, const Offset(-300, 0));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    expect(shownNames(tester), ['Bože, chválí tebe']);
  });

  testWidgets('emptied playlist keeps its last item on display screen', (tester) async {
    final selectedNotifier = ValueNotifier(DisplayScreenArguments(items: [createSongLyric(id: 2)]));
    final store = await pumpPlaylist(tester, selectedNotifier: selectedNotifier);

    await tester.runAsync(() async => store.box<PlaylistRecord>().removeAll());
    await pumpUntil(tester, () => shownNames(tester).isEmpty);

    expect(shownNames(tester), isEmpty);
    expect(selectedNotifier.value.items, [createSongLyric(id: 2)]);
  });
}
