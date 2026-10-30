import 'dart:typed_data';

import 'package:proscholy_common/custom/sqlite-bm25/bm25.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/utils/data.dart';
import 'package:sqflite/sqflite.dart';

// [name, secondary_name_1, secondary_name_2, lyrics, authors, hymnology]
const _searchResultsWeights = [40.0, 35.0, 30.0, 1.0, 2.0, 5.0];

const _createTableQuery =
    'CREATE VIRTUAL TABLE IF NOT EXISTS song_lyrics_search USING FTS4(name, secondary_name_1, secondary_name_2, lyrics, authors, hymnology, tokenize=unicode61);';

const _upsertQuery =
    'INSERT OR REPLACE INTO song_lyrics_search(rowid, name, secondary_name_1, secondary_name_2, lyrics, authors, hymnology) VALUES(?, ?, ?, ?, ?, ?, ?);';

const _selectQuery =
    'SELECT rowid, matchinfo(song_lyrics_search, "pcnalx") as info FROM song_lyrics_search WHERE song_lyrics_search MATCH ?;';

const _dropTableQuery = 'DROP TABLE song_lyrics_search';

const _optimizeQuery = "INSERT INTO song_lyrics_search(song_lyrics_search) VALUES('optimize');";

// full-text search of song lyrics, results are ranked by bm25
class FTSSearch {
  final Database database;
  final Box<SongLyric> songLyricsBox;

  const FTSSearch({required this.database, required this.songLyricsBox});

  Future<void> drop() async {
    try {
      await database.execute(_dropTableQuery);
    } on DatabaseException {
      // ignore exceptions if database does not exist
    }
  }

  Future<void> update(List<SongLyric> songLyrics) async {
    await database.execute(_createTableQuery);

    final batch = database.batch();

    for (final songLyric in songLyrics) {
      batch.execute(_upsertQuery, [
        songLyric.id,
        songLyric.displayName,
        songLyric.secondaryName1,
        songLyric.secondaryName2,
        songLyric.lyrics?.replaceAll(chordRE, ''),
        songLyric.authors.map((author) => author.name).join(','),
        songLyric.hymnology,
      ]);
    }

    await batch.commit();
  }

  // merges index into one segment and gives free space of database back, e.g. after index is built again
  Future<void> compact() async {
    await database.execute(_optimizeQuery);
    await database.execute('VACUUM');
  }

  // song lyrics matching full-text `query` from the best one, the ones with id in `ignore` are left out
  Future<List<SongLyric>> search(String query, {Set<int> ignore = const {}}) async {
    final ranks = <int, double>{};
    final searchResults = <int>[];

    for (final value in await database.rawQuery(_selectQuery, [query])) {
      final songLyricId = value['rowid'] as int;

      if (!ignore.contains(songLyricId)) {
        searchResults.add(songLyricId);
        ranks[songLyricId] = bm25(value['info'] as Uint8List, weights: _searchResultsWeights);
      }
    }

    searchResults.sort((a, b) => ranks[a]!.compareTo(ranks[b]!));

    return (await songLyricsBox.getManyAsync(searchResults)).nonNulls.toList();
  }
}
