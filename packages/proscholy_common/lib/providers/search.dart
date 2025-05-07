import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:proscholy_common/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:proscholy_common/custom/sqlite-bm25/bm25.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/song_lyrics.dart';
import 'package:proscholy_common/providers/utils.dart';

part 'generated/search.freezed.dart';
part 'generated/search.g.dart';

final _numberRE = RegExp(r'[1-9]\d*[A-Z]?');

// [name, secondary_name_1, secondary_name_2, lyrics, authors, hymnology]
const _searchResultsWeights = [40.0, 35.0, 30.0, 1.0, 2.0, 5.0];

const _createTableQuery =
    'CREATE VIRTUAL TABLE IF NOT EXISTS song_lyrics_search USING FTS4(name, secondary_name_1, secondary_name_2, lyrics, authors, hymnology, tokenize=unicode61);';

const _upsertQuery =
    'INSERT OR REPLACE INTO song_lyrics_search(rowid, name, secondary_name_1, secondary_name_2, lyrics, authors, hymnology) VALUES(?, ?, ?, ?, ?, ?, ?);';

const _selectQuery =
    'SELECT rowid, matchinfo(song_lyrics_search, "pcnalx") as info FROM song_lyrics_search WHERE song_lyrics_search MATCH ?;';

@riverpod
class SearchText extends _$SearchText {
  @override
  String build() => '';

  void change(String searchText) => state = searchText;
}

@riverpod
class SearchedSongLyrics extends _$SearchedSongLyrics {
  String? _currentSearchText;

  @override
  SearchedSongLyricsResult build() {
    ref.listen(searchTextProvider, (_, searchText) async {
      _currentSearchText = searchText;

      final result = await _search(searchText);

      if (_currentSearchText == searchText) state = result;
    });

    return const SearchedSongLyricsResult();
  }

  static Future<void> update(Database ftsDatabase, List<SongLyric> songLyrics) async {
    await ftsDatabase.execute(_createTableQuery);

    final batch = ftsDatabase.batch();

    for (final songLyric in songLyrics) {
      batch.execute(_upsertQuery, [
        songLyric.id,
        songLyric.name,
        songLyric.secondaryName1,
        songLyric.secondaryName2,
        songLyric.lyrics,
        songLyric.authors.map((author) => author.name).join(','),
        songLyric.hymnology,
      ]);
    }

    await batch.commit();
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
      if (isZP) {
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

    final ranks = <int, double>{};
    final searchResults = <int>[];

    for (final value in await ref.read(appDependenciesProvider).ftsDatabase.rawQuery(_selectQuery, [searchText])) {
      final songLyricId = value['rowid'] as int;

      if (!matchedIds.contains(songLyricId)) {
        searchResults.add(songLyricId);
        ranks[songLyricId] = bm25(value['info'] as Uint8List, weights: _searchResultsWeights);
      }
    }

    searchResults.sort((a, b) => ranks[a]!.compareTo(ranks[b]!));

    final songLyrics = await songLyricBox.getManyAsync(searchResults);

    return SearchedSongLyricsResult(
      songLyrics: songLyrics.whereNotNull().toList(),
      searchedNumber: searchedNumber,
      matchedById: matchedById,
      matchedBySongbookNumber: matchedBySongbookNumber,
    );
  }
}

@freezed
sealed class SearchedSongLyricsResult with _$SearchedSongLyricsResult {
  const factory SearchedSongLyricsResult({
    List<SongLyric>? songLyrics,
    String? searchedNumber,
    SongLyric? matchedById,
    @Default([]) List<SongLyric> matchedBySongbookNumber,
  }) = _SearchedSongLyricsResult;
}
