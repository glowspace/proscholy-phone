import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/providers/search.dart';
import 'package:proscholy_common/utils/data.dart';

import '../utils.dart';

void main() {
  late ProviderContainer container;

  Future<SearchedSongLyricsResult> search(String searchText) async {
    // clear previous result
    container.read(searchTextProvider.notifier).change('');
    await pumpEventQueue();

    container.read(searchTextProvider.notifier).change(searchText);

    await eventually(() => expect(container.read(searchedSongLyricsProvider).songLyrics, isNotNull));

    return container.read(searchedSongLyricsProvider);
  }

  setUp(() async {
    final appDependencies = await createAppDependencies();
    final data = readTestData();

    await parseAndStoreData(appDependencies.store, data);

    final songLyrics = await storeSongLyrics(
      appDependencies.store,
      [
        ...readJsonList(data[SongLyric.fieldKey], mapper: SongLyric.fromJson),
        createSongLyric(id: 10, name: 'Krále chválím', lyrics: 'Jiný text'),
      ],
    );

    await SearchedSongLyrics.update(appDependencies.ftsDatabase, songLyrics);

    container = createContainer(appDependencies);
    container.listen(searchedSongLyricsProvider, (_, _) {});
  });

  test('empty search text has no results', () async {
    container.read(searchTextProvider.notifier).change('  ');

    await pumpEventQueue();

    expect(container.read(searchedSongLyricsProvider), const SearchedSongLyricsResult());
  });

  test('searches in names and lyrics', () async {
    expect((await search('srdce')).songLyrics?.map((songLyric) => songLyric.id), [1]);
    expect((await search('text')).songLyrics?.map((songLyric) => songLyric.id), [10]);
  });

  test('searches by word prefixes', () async {
    expect((await search('chvál')).songLyrics?.map((songLyric) => songLyric.id), unorderedEquals([2, 10]));
    expect((await search('bož chv')).songLyrics?.map((songLyric) => songLyric.id), [2]);
  });

  test('match in name is ranked higher than match in lyrics', () async {
    expect((await search('krále')).songLyrics?.map((songLyric) => songLyric.id), [10, 1]);
  });

  test('searches by number', () async {
    final result = await search('8');

    expect(result.searchedNumber, '8');

    if (isEK) {
      expect(result.matchedById?.id, 2);
      expect(result.matchedBySongbookNumber, isEmpty);
    } else {
      expect(result.matchedById, isNull);
      expect(result.matchedBySongbookNumber.map((songLyric) => songLyric.id), [2]);
    }
  });

  test('searches by song lyric id only in ZPS', () async {
    final result = await search('10');

    expect(result.matchedById?.id, isZPS ? 10 : null);
  });
}
