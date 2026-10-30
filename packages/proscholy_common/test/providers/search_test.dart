import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/songbook.dart';
import 'package:proscholy_common/models/songbook_record.dart';
import 'package:proscholy_common/models/tag.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/playlists.dart';
import 'package:proscholy_common/providers/search.dart';
import 'package:proscholy_common/providers/song_lyrics.dart';
import 'package:proscholy_common/providers/svgs.dart';
import 'package:proscholy_common/providers/sort.dart';
import 'package:proscholy_common/providers/tags.dart';
import 'package:proscholy_common/utils/data.dart';
import 'package:proscholy_common/views/app_dependencies.dart';

import '../utils.dart';

class _FakeSvgs extends Svgs {
  @override
  Map<String, FileSystemEntity> build() => {};
}

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

    await appDependencies.ftsSearch.update(songLyrics);

    container = createContainer(appDependencies, overrides: [svgsProvider.overrideWith(_FakeSvgs.new)]);
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

  test('chords are not searched', () async {
    expect((await search('dmaj7')).songLyrics, isEmpty);
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

  test('searches by number in songbook with shortcut', () async {
    // song lyric 1 has number 12 in EZ, song lyric 10 doesn't have number in songbooks
    final result = await search('ez 12');

    expect(result.searchedNumber, '12');

    if (isEZ) {
      expect(result.matchedById?.id, 1);
      expect(result.matchedBySongbookNumber, isEmpty);
    } else {
      expect(result.matchedById, isNull);
      expect(result.matchedBySongbookNumber.map((songLyric) => songLyric.id), [1]);
    }
  });

  test('word before number that is not shortcut of songbook is searched as text', () async {
    final result = await search('chválím 10');

    expect(result.matchedById?.id, isZPS ? 10 : null);
    expect(result.matchedBySongbookNumber, isEmpty);
  });

  group('filters', skip: isZPS ? false : 'filters are only in ZPS', () {
    List<int> filteredIds() => [
      for (final songLyric in container.read(filteredSongLyricsProvider).songLyrics!) songLyric.id,
    ]..sort();

    setUp(() async {
      container.listen(filteredSongLyricsProvider, (_, _) {});

      // all song lyrics are loaded in another isolate
      await container.read(songLyricsProvider.future);
    });

    test('song lyrics match any selected tag of each tag type', () {
      final store = container.read(appDependenciesProvider).store;
      final selectedTags = container.read(selectedTagsProvider.notifier);

      // only song lyric 1 has these tags
      selectedTags.toggleSelection(store.box<Tag>().get(9)!);
      selectedTags.toggleSelection(store.box<Tag>().get(16)!);
      selectedTags.toggleSelection(store.box<Songbook>().get(58)!.tag);
      expect(filteredIds(), [1]);

      selectedTags.toggleSelection(store.box<Tag>().get(9)!);
      selectedTags.toggleSelection(store.box<Tag>().get(16)!);
      expect(filteredIds(), [1, 2]);

      selectedTags.toggleSelection(Tag.fromLanguage(0, 'Čeština', 1));
      expect(filteredIds(), isEmpty);

      selectedTags.toggleSelection(Tag.fromLanguage(1, 'čeština', 2));
      expect(filteredIds(), [1, 2]);
    });

    test('song lyrics in selected playlist', () {
      final playlist = container.read(playlistsProvider.notifier).addPlaylist(Playlist.empty('Mše'));

      container
          .read(playlistProvider(playlist.id).notifier)
          .addSongLyric(container.read(appDependenciesProvider).store.box<SongLyric>().get(2)!);
      container.read(selectedTagsProvider.notifier).toggleSelection(Tag.fromPlaylist(playlist));

      expect(filteredIds(), [2]);
    });

    test('song lyrics of one songbook are in its order when sorted by numbers', () {
      final store = container.read(appDependenciesProvider).store;

      store.box<SongbookRecord>().put(
        SongbookRecord(id: 9999, number: '1', songLyric: ToOne(targetId: 10), songbook: ToOne(targetId: 58)),
      );

      container.read(sortProvider.notifier).change(SortType.numeric);
      container.read(selectedTagsProvider.notifier).toggleSelection(store.box<Songbook>().get(58)!.tag);

      expect(container.read(filteredSongLyricsProvider).songLyrics!.map((songLyric) => songLyric.id), [10, 1, 2]);
    });
  });

  // songbook tags give order of songbook in search on EZ and EK too, where tags can't be selected in filters
  test('closing search clears tags of all types', () {
    final songbookTag = container.read(appDependenciesProvider).store.box<Songbook>().get(58)!.tag;
    final selectedTags = container.read(selectedTagsProvider.notifier);

    selectedTags.push(initialTags: [songbookTag]);
    selectedTags.pop();

    expect(container.read(selectedTagsByTypeProvider(TagType.songbook)), isEmpty);

    selectedTags.push(initialTags: [songbookTag]);

    expect(container.read(selectedTagsByTypeProvider(TagType.songbook)), {songbookTag});
  });
}
