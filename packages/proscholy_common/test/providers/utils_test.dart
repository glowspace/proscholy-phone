import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/external.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/settings.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/songbook_record.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/providers/utils.dart';

import '../utils.dart';

Future<List<SongLyric>> _parseAndStore(Store store) async {
  final data = readTestData();

  await parseAndStoreData(store, data);

  return storeSongLyrics(store, readJsonList(data[SongLyric.fieldKey], mapper: SongLyric.fromJson));
}

void main() {
  test('parse and store data', () async {
    final store = await openTestStore();

    final songLyrics = await _parseAndStore(store);

    expect(songLyrics.map((songLyric) => songLyric.id), [1, 2]);

    final songLyric = store.box<SongLyric>().get(1)!;

    expect(songLyric.authors.map((author) => author.name), unorderedEquals(['Tomáš Coufal', 'Jana Hlavsová']));
    expect(songLyric.tags.map((tag) => tag.name), unorderedEquals(['chvály', 'závěr']));
    expect(songLyric.song.target?.name, 'Otwórz me oczy o Panie');
    expect(songLyric.externals.map((external) => external.songLyric.targetId), [1, 1]);
    expect(
      songLyric.songbookRecords.map((songbookRecord) => songbookRecord.songbook.target?.shortcut),
      unorderedEquals(['3Ch', 'EZ', 'EK']),
    );
  });

  test('arrangements are not stored', () async {
    final store = await openTestStore();

    await _parseAndStore(store);

    expect(store.box<SongLyric>().get(3), isNull);
  });

  test('storing again does not duplicate relations', () async {
    final store = await openTestStore();

    await _parseAndStore(store);
    await _parseAndStore(store);

    expect(store.box<SongLyric>().count(), 2);
    expect(store.box<External>().count(), 2);
    expect(store.box<SongbookRecord>().count(), 5);
  });

  test('storing again keeps song lyric settings', () async {
    final store = await openTestStore();

    await _parseAndStore(store);

    final settingsId = store.box<SongLyricSettingsModel>().put(
      SongLyricSettingsModel(
        id: 1,
        showChords: false,
        showMusicalNotes: true,
        transposition: 2,
        songLyric: ToOne(targetId: 1),
      ),
    );
    store.box<SongLyric>().put(store.box<SongLyric>().get(1)!..settings.targetId = settingsId);

    await _parseAndStore(store);

    expect(store.box<SongLyric>().get(1)!.settings.target?.transposition, 2);
  });
}
