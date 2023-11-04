import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zpevnik/custom/sqlite-bm25/bm25.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/app_dependencies.dart';
import 'package:zpevnik/providers/utils.dart';

part 'search.freezed.dart';
part 'search.g.dart';

final _numberRE = RegExp(r'\d+');

// [name, secondary_name_1, secondary_name_2, lyrics]
const _searchResultsWeights = [40.0, 35.0, 30.0, 1.0];

const _createTableQuery =
    'CREATE VIRTUAL TABLE IF NOT EXISTS song_lyrics_search USING FTS4(name, secondary_name_1, secondary_name_2, lyrics, tokenize=unicode61);';

const _upsertQuery =
    'INSERT OR REPLACE INTO song_lyrics_search(rowid, name, secondary_name_1, secondary_name_2, lyrics) VALUES(?, ?, ?, ?, ?);';

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
      ]);
    }

    await batch.commit();
  }

  Future<SearchedSongLyricsResult> _search(String searchText) async {
    searchText = searchText.trim();

    if (searchText.isEmpty) return const SearchedSongLyricsResult();

    final searchedNumber = _numberRE.firstMatch(searchText)?.group(0);
    final songLyricBox =
        ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store.box<SongLyric>()));
    final matchedIds = <int>{};

    SongLyric? matchedById;
    final matchedBySongbookNumber = <SongLyric>[];

    if (searchedNumber == null) {
      searchText = '${searchText.replaceAll(' ', '* ')}*';
    } else {
      matchedById = songLyricBox.get(int.parse(searchedNumber));

      if (matchedById != null) matchedIds.add(matchedById.id);

      final songbookRecords = queryStore(ref, condition: SongbookRecord_.number.equals(searchedNumber));
      songbookRecords.sort((a, b) => a.songbook.target!.compareTo(b.songbook.target!));

      for (final songbookRecord in songbookRecords) {
        if (matchedIds.contains(songbookRecord.songLyric.targetId)) continue;

        matchedIds.add(songbookRecord.songLyric.targetId);
        matchedBySongbookNumber.add(songbookRecord.songLyric.target!);
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
class SearchedSongLyricsResult with _$SearchedSongLyricsResult {
  const factory SearchedSongLyricsResult({
    List<SongLyric>? songLyrics,
    String? searchedNumber,
    SongLyric? matchedById,
    @Default([]) List<SongLyric> matchedBySongbookNumber,
  }) = _SearchedSongLyricsResult;
}
