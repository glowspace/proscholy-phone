import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/author.dart';
import 'package:proscholy_common/providers/search.dart';

import 'utils.dart';

void main() {
  test('objectbox store', () async {
    final store = await openTestStore();

    store.box<Author>().put(const Author(id: 1, name: 'Author'));

    expect(store.box<Author>().get(1)?.name, 'Author');
  });

  test('fts database', () async {
    final database = await openTestFtsDatabase();

    await SearchedSongLyrics.update(database, []);

    expect(await database.query('song_lyrics_search'), isEmpty);
  });
}
