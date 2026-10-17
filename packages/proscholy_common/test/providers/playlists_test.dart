import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/custom_text.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/playlist_record.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/playlists.dart';
import 'package:proscholy_common/providers/settings.dart';
import 'package:proscholy_common/providers/utils.dart';

import '../utils.dart';

void main() {
  late ProviderContainer container;
  late Playlists notifier;

  SongLyric songLyric(int id) => container.read(appDependenciesProvider).store.box<SongLyric>().get(id)!;

  Playlist playlist(int id) => container.read(appDependenciesProvider).store.box<Playlist>().get(id)!;

  List<PlaylistRecord> sortedRecords(Playlist playlist) {
    return [...playlist.records]..sort((a, b) => a.rank.compareTo(b.rank));
  }

  List<String> records(Playlist playlist) {
    return [
      for (final playlistRecord in sortedRecords(playlist))
        playlistRecord.songLyric.target?.name ??
            playlistRecord.customText.target?.name ??
            playlistRecord.bibleVerse.target!.displayName,
    ];
  }

  setUp(() async {
    final appDependencies = await createAppDependencies();
    final data = readTestData();

    await parseAndStoreData(appDependencies.store, data);
    await storeSongLyrics(appDependencies.store, readJsonList(data[SongLyric.fieldKey], mapper: SongLyric.fromJson));

    container = createContainer(appDependencies);
    // favorites playlist is created during start of the app
    container.read(favoritePlaylistProvider);
    container.listen(playlistsProvider, (_, _) {});
    notifier = container.read(playlistsProvider.notifier);
  });

  test('new playlist is first', () {
    final first = notifier.createPlaylist('První');
    final second = notifier.createPlaylist('Druhý');

    expect(container.read(playlistsProvider).map((playlist) => playlist.name), ['Druhý', 'První']);
    expect(playlist(first.id).rank, 1);
    expect(playlist(second.id).rank, 0);
  });

  test('rename, reorder and remove', () {
    final first = notifier.createPlaylist('První');
    notifier.createPlaylist('Druhý');
    notifier.createPlaylist('Třetí');

    notifier.renamePlaylist(first, 'Přejmenovaný');
    notifier.reorderPlaylists(2, 0);

    expect(container.read(playlistsProvider).map((playlist) => playlist.name), ['Přejmenovaný', 'Třetí', 'Druhý']);

    notifier.removePlaylist(container.read(playlistsProvider).first);

    expect(container.read(playlistsProvider).map((playlist) => playlist.name), ['Třetí', 'Druhý']);
  });

  test('add records', () {
    final newPlaylist = notifier.createPlaylist('Mše');

    notifier.addToPlaylist(newPlaylist, songLyric: songLyric(1));
    notifier.addToPlaylist(
      newPlaylist,
      customText: notifier.createCustomText(name: 'Ohlášky', content: 'text'),
    );
    notifier.addToPlaylist(
      newPlaylist,
      bibleVerse: notifier.createBibleVerse(book: 18, chapter: 23, startVerse: 1, text: 'Hospodin je můj pastýř'),
    );
    // inserted after first record
    notifier.addToPlaylist(newPlaylist, songLyric: songLyric(2), afterRank: 0);
    // duplicate is ignored
    notifier.addToPlaylist(newPlaylist, songLyric: songLyric(1));

    expect(records(playlist(newPlaylist.id)), [
      'Ať srdce mé tebe vídá',
      'Bože, chválí tebe',
      'Ohlášky',
      'Žalmy 23:1',
    ]);
  });

  test('removing record removes its custom text', () {
    final newPlaylist = notifier.createPlaylist('Mše');
    final customText = notifier.createCustomText(name: 'Ohlášky', content: 'text');

    notifier.addToPlaylist(newPlaylist, customText: customText);

    final playlistRecord = playlist(newPlaylist.id).records.single;

    notifier.removeFromPlaylist(newPlaylist, playlistRecord);

    final store = container.read(appDependenciesProvider).store;

    expect(store.box<PlaylistRecord>().get(playlistRecord.id), isNull);
    expect(store.box<CustomText>().get(customText.id), isNull);
  });

  test('duplicated playlist has own custom texts', () {
    final original = notifier.createPlaylist('Mše');

    notifier.addToPlaylist(original, songLyric: songLyric(1));
    notifier.addToPlaylist(
      original,
      customText: notifier.createCustomText(name: 'Ohlášky', content: 'text'),
    );

    final duplicate = notifier.duplicatePlaylist(playlist(original.id), 'Mše (kopie)');

    expect(records(playlist(duplicate.id)), records(playlist(original.id)));

    final originalCustomText = sortedRecords(playlist(original.id)).last.customText.targetId;
    final duplicatedCustomText = sortedRecords(playlist(duplicate.id)).last.customText.targetId;

    expect(duplicatedCustomText, isNot(originalCustomText));
  });

  test('shared playlist is accepted with song lyric settings', () {
    final original = notifier.createPlaylist('Mše');

    notifier.addToPlaylist(original, songLyric: songLyric(1));
    notifier.addToPlaylist(
      original,
      customText: notifier.createCustomText(name: 'Ohlášky', content: 'text'),
    );
    notifier.addToPlaylist(
      original,
      bibleVerse: notifier.createBibleVerse(book: 18, chapter: 23, startVerse: 1, endVerse: 2, text: 'Hospodin'),
    );

    container.listen(songLyricSettingsProvider(1), (_, _) {});
    container.read(songLyricSettingsProvider(1).notifier).changeTransposition(3);

    final sharedPlaylist = notifier.playlistToMap(playlist(original.id));

    expect(sharedPlaylist['name'], 'Mše');
    expect((sharedPlaylist['records'] as List).first['song_lyric'], {'id': 1, 'accidentals': null, 'transposition': 3});

    container.read(songLyricSettingsProvider(1).notifier).resetTransposition();

    final accepted = notifier.acceptPlaylist(sharedPlaylist, 'Přijatý');

    expect(records(playlist(accepted.id)), records(playlist(original.id)));
    expect(container.read(songLyricSettingsProvider(1)).transposition, 3);
  });

  test('toggle favorite', () {
    notifier.toggleFavorite(songLyric(1));

    expect(songLyric(1).isFavorite, isTrue);
    expect(records(container.read(favoritePlaylistProvider)), ['Ať srdce mé tebe vídá']);

    notifier.toggleFavorite(songLyric(1));

    expect(songLyric(1).isFavorite, isFalse);
  });
}
