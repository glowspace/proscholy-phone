import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/author.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/utils/fts_search.dart';

import 'utils.dart';

void main() {
  test('objectbox store', () async {
    final store = await openTestStore();

    store.box<Author>().put(const Author(id: 1, name: 'Author'));

    expect(store.box<Author>().get(1)?.name, 'Author');
  });

  test('fts database', () async {
    final database = await openTestFtsDatabase();
    final store = await openTestStore();

    await FTSSearch(database: database, songLyricsBox: store.box<SongLyric>()).update([]);

    expect(await database.query('song_lyrics_search'), isEmpty);
  });
}
