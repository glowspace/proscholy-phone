import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/settings.dart';
import 'package:proscholy_common/models/song_lyric.dart';

// `test/data/old_store` was saved by the app before models were renamed, it contains playlist with song lyric, custom
// text and bible verse, favorite song lyric and its transposition, these must not be lost when models change
void main() {
  test('user data are kept after upgrade of old store', () async {
    final directory = await Directory.systemTemp.createTemp('proscholy_store_');

    File('test/data/old_store/data.mdb').copySync('${directory.path}/data.mdb');

    final store = await openStore(directory: directory.path);

    addTearDown(() {
      store.close();
      directory.deleteSync(recursive: true);
    });

    final query = store.box<Playlist>().query(Playlist_.name.equals('Mše')).build();
    final records = query.findUnique()!.records.sorted((a, b) => a.rank.compareTo(b.rank));

    query.close();

    expect(records.map((record) => record.songLyric.targetId), [1, 0, 0]);
    expect(records[1].customText.target?.name, 'Ohlášky');
    expect(records[2].biblePassage.target?.text, 'Na počátku stvořil Bůh nebe a zemi.');

    expect(store.box<Playlist>().get(favoritesPlaylistId)!.records.single.songLyric.targetId, 1);

    final settingsQuery = store
        .box<SongLyricSettingsModel>()
        .query(SongLyricSettingsModel_.songLyric.equals(1))
        .build();

    expect(settingsQuery.findUnique()?.transposition, 2);

    settingsQuery.close();

    expect(store.box<SongLyric>().get(1), isNotNull);
  });
}
