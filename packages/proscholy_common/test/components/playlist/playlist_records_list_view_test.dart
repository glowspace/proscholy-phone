import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/components/playlist/playlist_record_row.dart';
import 'package:proscholy_common/components/playlist/playlist_records_list_view.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/playlist_record.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/utils.dart';

import '../../utils.dart';

PlaylistRecord _record(int id, int songLyricId) {
  return PlaylistRecord(
    id: id,
    rank: id,
    songLyric: ToOne(targetId: songLyricId),
    customText: ToOne(),
    bibleVerse: ToOne(),
    playlist: ToOne(targetId: 2),
  );
}

void main() {
  late ValueNotifier<bool> sortedAlphabeticallyNotifier;

  Future<void> pumpPlaylist(WidgetTester tester) async {
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

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDependenciesProvider.overrideWithValue(appDependencies)],
        child: MaterialApp(
          home: Scaffold(
            body: PlaylistRecordsListView(
              playlist: playlist,
              sortedAlphabeticallyNotifier: sortedAlphabeticallyNotifier,
            ),
          ),
        ),
      ),
    );
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
}
