import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:proscholy_common/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/song_lyrics.dart';
import 'package:proscholy_common/providers/utils.dart';
import 'package:proscholy_common/views/app_dependencies.dart';

part 'generated/search.freezed.dart';
part 'generated/search.g.dart';

final _numberRE = RegExp(r'[1-9]\d*[A-Z]?');

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
      if (isZPS) {
        final searchId = int.tryParse(searchedNumber);
        if (searchId != null) matchedById = songLyricBox.get(searchId);

        if (matchedById != null) matchedIds.add(matchedById.id);
      }

      final songbookRecords = queryStore(ref, condition: SongbookRecord_.number.equals(searchText));
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

@Freezed(equal: true)
sealed class SearchedSongLyricsResult with _$SearchedSongLyricsResult {
  const factory SearchedSongLyricsResult({
    List<SongLyric>? songLyrics,
    String? searchedNumber,
    SongLyric? matchedById,
    @Default([]) List<SongLyric> matchedBySongbookNumber,
  }) = _SearchedSongLyricsResult;
}
