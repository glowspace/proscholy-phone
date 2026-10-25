import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/songbook.dart';
import 'package:proscholy_common/models/tag.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/song_lyrics.dart';
import 'package:proscholy_common/providers/songbooks.dart';
import 'package:proscholy_common/providers/sort.dart';
import 'package:proscholy_common/providers/tags.dart';
import 'package:proscholy_common/providers/utils.dart';
import 'package:proscholy_common/views/app_dependencies.dart';
import 'package:proscholy_common/views/tag.dart';

part 'generated/search.freezed.dart';
part 'generated/search.g.dart';

final _numberRE = RegExp(r'[1-9]\d*[A-Z]?');
// number in songbook preceded by shortcut of the songbook, e.g. "EZ 12"
final _shortcutNumberRE = RegExp(r'^(\S+)\s+([1-9]\d*[A-Z]?)$');

@riverpod
class SearchText extends _$SearchText {
  final String? initialText;

  SearchText({this.initialText});

  @override
  String build() => initialText ?? '';

  void change(String searchText) {
    if (ref.mounted) state = searchText;
  }
}

@riverpod
class SearchedSongLyrics extends _$SearchedSongLyrics {
  String? _currentSearchText;

  @override
  SearchedSongLyricsResult build() {
    final initialSearchText = ref.read(searchTextProvider.notifier).initialText;

    if (initialSearchText != null) {
      _currentSearchText = initialSearchText;

      _search(initialSearchText).then((result) {
        if (_currentSearchText == initialSearchText) state = result;
      });
    }

    ref.listen(searchTextProvider, (_, searchText) async {
      _currentSearchText = searchText;

      final result = await _search(searchText);

      if (_currentSearchText == searchText) state = result;
    });

    return const SearchedSongLyricsResult();
  }

  Future<SearchedSongLyricsResult> _search(String searchText) async {
    searchText = searchText.trim();

    if (searchText.isEmpty) return const SearchedSongLyricsResult();

    final searchedNumber = _numberRE.firstMatch(searchText)?.group(0);
    final songLyricBox = ref.read(appDependenciesProvider).store.box<SongLyric>();
    final matchedIds = <int>{};

    SongLyric? matchedById;
    final matchedBySongbookNumber = <SongLyric>[];

    if (searchedNumber == null) {
      searchText = '${searchText.replaceAll(' ', '* ')}*';
    } else {
      final shortcutNumberMatch = _shortcutNumberRE.firstMatch(searchText);
      final songbookIds = {
        if (shortcutNumberMatch != null)
          for (final songbook in ref.read(appDependenciesProvider).store.box<Songbook>().getAll())
            if (songbook.shortcut.toLowerCase() == shortcutNumberMatch.group(1)!.toLowerCase()) songbook.id,
      };

      if (isZPS && songbookIds.isEmpty) {
        final searchId = int.tryParse(searchedNumber);
        if (searchId != null) matchedById = songLyricBox.get(searchId);

        if (matchedById != null) matchedIds.add(matchedById.id);
      }

      final songbookRecords = songbookIds.isEmpty
          ? queryStore(ref, condition: SongbookRecord_.number.equals(searchText))
          : queryStore(
              ref,
              condition: SongbookRecord_.number.equals(shortcutNumberMatch!.group(2)!),
            ).where((songbookRecord) => songbookIds.contains(songbookRecord.songbook.targetId)).toList();
      songbookRecords.sort((a, b) => a.songbook.target!.compareTo(b.songbook.target!));

      for (final songbookRecord in songbookRecords) {
        if (matchedIds.contains(songbookRecord.songLyric.targetId)) continue;

        matchedIds.add(songbookRecord.songLyric.targetId);

        final songLyric = ref.read(songLyricProvider(songbookRecord.songLyric.targetId));
        if (songLyric != null) {
          if (isEZ && songbookRecord.songbook.targetId == 58) {
            matchedById = songLyric;
          } else if (isEK && songbookRecord.songbook.targetId == 63) {
            matchedById = songLyric;
          } else {
            matchedBySongbookNumber.add(songLyric);
          }
        } else {
          Sentry.captureMessage(
            'missing song lyric from songbook record with id: $songbookRecord',
          );
        }
      }
    }

    final songLyrics = await ref.read(appDependenciesProvider).ftsSearch.search(searchText, ignore: matchedIds);

    return SearchedSongLyricsResult(
      songLyrics: songLyrics,
      searchedNumber: searchedNumber,
      matchedById: matchedById,
      matchedBySongbookNumber: matchedBySongbookNumber,
    );
  }
}

// search results, or all song lyrics when nothing is searched, that match the selected tags
@riverpod
SearchedSongLyricsResult filteredSongLyrics(Ref ref) {
  final searchedSongLyricsResult = ref.watch(searchedSongLyricsProvider);
  final songbookTags = ref.watch(selectedTagsByTypeProvider(TagType.songbook));

  final List<SongLyric> allSongLyrics;
  if (songbookTags.length == 1 &&
      ref.watch(searchTextProvider).isEmpty &&
      ref.watch(sortProvider) == SortType.numeric) {
    final songbook = ref.watch(songbooksProvider).firstWhere((songbook) => songbook.name == songbookTags.first.name);
    songbook.records.sort();

    allSongLyrics = songbook.records.map((songbookRecord) => songbookRecord.songLyric.target!).toList();
  } else {
    allSongLyrics = ref.watch(songLyricsProvider).value ?? [];
  }

  final matchesSelectedTags = _selectedTagsFilter(ref);
  final matchedById = searchedSongLyricsResult.matchedById;

  return SearchedSongLyricsResult(
    songLyrics: (searchedSongLyricsResult.songLyrics ?? allSongLyrics).where(matchesSelectedTags).toList(),
    searchedNumber: searchedSongLyricsResult.searchedNumber,
    matchedById: matchedById != null && matchesSelectedTags(matchedById) ? matchedById : null,
    matchedBySongbookNumber: searchedSongLyricsResult.matchedBySongbookNumber.where(matchesSelectedTags).toList(),
  );
}

// song lyric has to match any of the selected tags of each tag type, ids of matching song lyrics are found at once, so
// relations of every song lyric don't have to be loaded
bool Function(SongLyric) _selectedTagsFilter(Ref ref) {
  final store = ref.read(appDependenciesProvider).store;
  final filters = <bool Function(SongLyric)>[];

  for (final tagType in kSupportedTagTypes) {
    final selectedTags = ref.watch(selectedTagsByTypeProvider(tagType));

    if (selectedTags.isEmpty) continue;

    switch (tagType) {
      case TagType.language:
        final languages = {for (final tag in selectedTags) tag.name};

        filters.add((songLyric) => languages.contains(songLyric.langDescription));
      case TagType.songbook:
        final songLyricIds = {
          for (final tag in selectedTags)
            for (final songbookRecord in store.box<Songbook>().get(kSongbookTagIdOffset - tag.id)?.records ?? [])
              songbookRecord.songLyric.targetId,
        };

        filters.add((songLyric) => songLyricIds.contains(songLyric.id));
      case TagType.playlist:
        final songLyricIds = {
          for (final tag in selectedTags)
            for (final playlistRecord in store.box<Playlist>().get(kPlaylistTagIdOffset - tag.id)?.records ?? [])
              playlistRecord.songLyric.targetId,
        };

        filters.add((songLyric) => songLyricIds.contains(songLyric.id));
      default:
        final queryBuilder = store.box<SongLyric>().query()
          ..linkMany(SongLyric_.tags, Tag_.id.oneOf([for (final tag in selectedTags) tag.id]));
        final query = queryBuilder.build();
        final songLyricIds = query.findIds().toSet();

        query.close();

        filters.add((songLyric) => songLyricIds.contains(songLyric.id));
    }
  }

  return (songLyric) => filters.every((filter) => filter(songLyric));
}

@Freezed(equal: true)
sealed class SearchedSongLyricsResult with _$SearchedSongLyricsResult {
  const factory SearchedSongLyricsResult({
    List<SongLyric>? songLyrics,
    String? searchedNumber,
    SongLyric? matchedById,
    @Default([]) List<SongLyric> matchedBySongbookNumber,
  }) = _SearchedSongLyricsResult;
}
