import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zpevnik/models/song_lyric.dart';

const _createTableQuery =
    'CREATE VIRTUAL TABLE IF NOT EXISTS song_lyrics_search USING FTS4(id, name, secondary_name_1, secondary_name_2, lyrics, numbers_with_shortcut, numbers, tokenize=unicode61);';

const _upsertQuery =
    'INSERT OR REPLACE INTO song_lyrics_search(rowid, id, name, secondary_name_1, secondary_name_2, lyrics, numbers_with_shortcut, numbers) VALUES(?, ?, ?, ?, ?, ?, ?, ?);';

const _selectQuery =
    'SELECT id, matchinfo(song_lyrics_search, "pcnalx") as info FROM song_lyrics_search WHERE song_lyrics_search MATCH ?;';

final _numberRE = RegExp(r'^\d+$');

class SongLyricsSearch {
  late final Database _db;

  Future<void> init() async {
    _db = await openDatabase(join(await getDatabasesPath(), 'zpevnik.db'));

    await _db.execute(_createTableQuery);
  }

  Future<void> update(List<SongLyric> songLyrics) async {
    final batch = _db.batch();

    for (final songLyric in songLyrics) {
      batch.execute(_upsertQuery, [
        songLyric.id,
        songLyric.id,
        songLyric.name,
        songLyric.secondaryName1,
        songLyric.secondaryName2,
        songLyric.lyrics,
        songLyric.songbookRecords
            .map((songbookRecord) => '${songbookRecord.songbook.target!.shortcut}${songbookRecord.number}')
            .toString(),
        songLyric.songbookRecords.map((songbookRecord) => songbookRecord.number).toString()
      ]);
    }

    await batch.commit();
  }

  Future<List<dynamic>> search(String searchText) {
    if (!_numberRE.hasMatch(searchText)) searchText = searchText.replaceAll(' ', '* ');

    return _db.rawQuery(_selectQuery, [searchText]);
  }
}
