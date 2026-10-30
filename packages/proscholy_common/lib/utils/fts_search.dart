import 'dart:typed_data';

import 'package:proscholy_common/custom/sqlite-bm25/bm25.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/utils/data.dart';
import 'package:sqflite/sqflite.dart';

// [name, secondary_name_1, secondary_name_2, lyrics, authors, hymnology]
const _searchResultsWeights = [40.0, 35.0, 30.0, 1.0, 2.0, 5.0];

const _createTableQuery =
    'CREATE VIRTUAL TABLE IF NOT EXISTS song_lyrics_search USING FTS4(name, secondary_name_1, secondary_name_2, lyrics, authors, hymnology, content="", tokenize=unicode61);';

const _insertQuery =
    'INSERT INTO song_lyrics_search(rowid, name, secondary_name_1, secondary_name_2, lyrics, authors, hymnology) VALUES(?, ?, ?, ?, ?, ?, ?);';

const _selectQuery =
    'SELECT rowid, matchinfo(song_lyrics_search, "pcnalx") as info FROM song_lyrics_search WHERE song_lyrics_search MATCH ?;';

const _dropTableQuery = 'DROP TABLE IF EXISTS song_lyrics_search';

const _optimizeQuery = "INSERT INTO song_lyrics_search(song_lyrics_search) VALUES('optimize');";

// full-text search of song lyrics, results are ranked by bm25
class FTSSearch {
  final Database database;
  final Store store;

  const FTSSearch({required this.database, required this.store});

  // index keeps no copy of texts to take less space, so it can't change its rows and is built again from all song
  // lyrics, which are read in another isolate
  Future<void> rebuild() async {
    // search has an empty index until the first one is built
    await database.execute(_createTableQuery);

    final rows = await store.runAsync(_readRows, null);
    final batch = database.batch()
      ..execute(_dropTableQuery)
      ..execute(_createTableQuery);

    for (final row in rows) {
      batch.execute(_insertQuery, row);
    }

    batch.execute(_optimizeQuery);

    await batch.commit(noResult: true);

    // file of database would keep the size of previous index
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

    return (await store.box<SongLyric>().getManyAsync(searchResults)).nonNulls.toList();
  }
}

// values of all song lyrics in order of columns of index
List<List<Object?>> _readRows(Store store, void _) {
  return [
    for (final songLyric in store.box<SongLyric>().getAll())
      [
        songLyric.id,
        songLyric.displayName,
        songLyric.secondaryName1,
        songLyric.secondaryName2,
        songLyric.lyrics?.replaceAll(chordRE, ''),
        songLyric.authors.map((author) => author.name).join(','),
        songLyric.hymnology,
      ],
  ];
}
