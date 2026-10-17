import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/model.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/songbook.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/recent_items.dart';
import 'package:proscholy_common/providers/utils.dart';

import '../utils.dart';

List<String> _describe(List<RecentItem> recentItems) {
  return [for (final recentItem in recentItems) '${recentItem.recentItemType.name} ${recentItem.id}'];
}

void main() {
  late AppDependencies appDependencies;

  SongLyric songLyric(int id) => appDependencies.store.box<SongLyric>().get(id)!;

  Songbook songbook(int id) => appDependencies.store.box<Songbook>().get(id)!;

  setUp(() async {
    appDependencies = await createAppDependencies();

    final data = readTestData();

    await parseAndStoreData(appDependencies.store, data);
    await storeSongLyrics(appDependencies.store, [
      ...readJsonList(data[SongLyric.fieldKey], mapper: SongLyric.fromJson),
      createSongLyric(id: 10),
    ]);
  });

  test('keeps last five items without duplicates', () {
    final container = createContainer(appDependencies);
    container.listen(recentItemsProvider, (_, _) {});
    final notifier = container.read(recentItemsProvider.notifier);

    notifier.add(songLyric(1));
    notifier.add(songbook(9));
    notifier.add(songbook(58));
    notifier.add(songLyric(2));
    notifier.add(songbook(63));
    notifier.add(songLyric(1));

    expect(_describe(container.read(recentItemsProvider)), [
      'songLyric 1',
      'songbook 63',
      'songLyric 2',
      'songbook 58',
      'songbook 9',
    ]);

    notifier.add(songLyric(10));

    expect(_describe(container.read(recentItemsProvider)), [
      'songLyric 10',
      'songLyric 1',
      'songbook 63',
      'songLyric 2',
      'songbook 58',
    ]);
  });

  test('recent items are persisted', () {
    final container = createContainer(appDependencies);
    container.listen(recentItemsProvider, (_, _) {});

    container.read(recentItemsProvider.notifier).add(songbook(9));
    container.read(recentItemsProvider.notifier).add(songLyric(1));

    expect(
      _describe(createContainer(appDependencies).read(recentItemsProvider)),
      unorderedEquals(['songbook 9', 'songLyric 1']),
    );
  });

  test('recent song lyrics are persisted in order', () {
    final container = createContainer(appDependencies);
    container.listen(recentSongLyricsProvider, (_, _) {});

    container.read(recentSongLyricsProvider.notifier).add(songLyric(1));
    container.read(recentSongLyricsProvider.notifier).add(songLyric(2));
    container.read(recentSongLyricsProvider.notifier).add(songLyric(1));

    expect(container.read(recentSongLyricsProvider).map((songLyric) => songLyric.id), [1, 2]);
    expect(createContainer(appDependencies).read(recentSongLyricsProvider).map((songLyric) => songLyric.id), [1, 2]);
  });
}
