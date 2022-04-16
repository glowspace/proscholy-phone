import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:zpevnik/models/model.dart';

extension SongLyricsSearch on Model {
  Future<BoolResult> _initSongLyricsSearch() {
    return execSQL(
        'CREATE VIRTUAL TABLE IF NOT EXISTS song_lyrics_search USING FTS4(id, name, secondary_name_1, secondary_name_2, lyrics, numbers, tokenize=unicode61);');
  }

  Future<void> updateSongLyricsSearch(
    List<SongLyric> songLyrics,
    List<Songbook> songbooks,
    List<SongbookRecord> songbookRecords,
  ) async {
    await _initSongLyricsSearch();

    final songbooksMap = Map<int, Songbook>.fromIterable(songbooks, key: (songbook) => songbook.id);
    final songbookNumbersMap = Map<int, List<String>>.from({});

    for (final songbookRecord in songbookRecords) {
      final songLyricId = songbookRecord.song_lyricsId;

      if (songLyricId == null) continue;

      if (!songbookNumbersMap.containsKey(songLyricId)) songbookNumbersMap[songLyricId] = [];

      songbookNumbersMap[songLyricId]!
          .add('${songbooksMap[songbookRecord.songbooksId]?.shortcut}${songbookRecord.number}');
      songbookNumbersMap[songLyricId]!.add(songbookRecord.number ?? '');
    }

    final existing = {};
    for (final map in (await execDataTable('SELECT id from song_lyrics_search'))) {
      existing[map['id']] = true;
    }

    await batchStart();

    for (final songLyric in songLyrics) {
      if (existing[songLyric.id] ?? false) {
        await execSQL(
            'UPDATE song_lyrics_search SET name = ?, secondary_name_1 = ?, secondary_name_2 = ?, lyrics = ?, numbers = ? WHERE id = ?;',
            [
              songLyric.name,
              songLyric.secondary_name_1,
              songLyric.secondary_name_2,
              songLyric.lyrics,
              songbookNumbersMap[songLyric.id].toString(),
              songLyric.id,
            ]);
      } else {
        await execSQL(
            'INSERT INTO song_lyrics_search(id, name, secondary_name_1, secondary_name_2, lyrics, numbers) VALUES(?, ?, ?, ?, ?, ?);',
            [
              songLyric.id,
              songLyric.name,
              songLyric.secondary_name_1,
              songLyric.secondary_name_2,
              songLyric.lyrics,
              songbookNumbersMap[songLyric.id].toString(),
            ]);
      }
    }

    await batchCommit();
  }

  Future<List<dynamic>?> searchSongLyrics(String searchText) {
    searchText = '$searchText*';
    return execDataTable(
        'SELECT id, matchinfo(song_lyrics_search, "pcnalx") as info FROM song_lyrics_search WHERE song_lyrics_search MATCH ?;',
        [searchText]);
  }
}
