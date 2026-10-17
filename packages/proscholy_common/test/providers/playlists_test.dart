import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/bible_passage.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/playlist_record.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/user_text.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/playlists.dart';
import 'package:proscholy_common/providers/settings.dart';
import 'package:proscholy_common/utils/data.dart';

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
            playlistRecord.userText.target?.name ??
            playlistRecord.biblePassage.target!.displayName,
    ];
  }

  Playlist createPlaylist(String name) => notifier.addPlaylist(Playlist.empty(name));

  PlaylistNotifier edit(Playlist playlist) => container.read(playlistProvider(playlist.id).notifier);

  setUp(() async {
    final appDependencies = await createAppDependencies();
    final data = readTestData();

    await parseAndStoreData(appDependencies.store, data);
    await storeSongLyrics(appDependencies.store, readJsonList(data[SongLyric.fieldKey], mapper: SongLyric.fromJson));

    container = createContainer(appDependencies);
    container.listen(playlistsProvider, (_, _) {});
    notifier = container.read(playlistsProvider.notifier);
  });

  // e.g. first playlist created from song lyric, before favorite playlist was ever shown
  test('new playlist does not take id of favorite playlist', () {
    final created = createPlaylist('První');

    notifier.toggleFavorite(songLyric(1));

    expect(created.id, isNot(favoritesPlaylistId));
    expect(playlist(favoritesPlaylistId).name, 'Písně s hvězdičkou');
    expect(records(playlist(created.id)), isEmpty);
  });

  test('new playlist is first', () {
    final first = createPlaylist('První');
    final second = createPlaylist('Druhý');

    expect(container.read(playlistsProvider).map((playlist) => playlist.name), ['Druhý', 'První']);
    expect(playlist(first.id).rank, 1);
    expect(playlist(second.id).rank, 0);
  });

  test('rename, reorder and remove', () {
    final first = createPlaylist('První');
    createPlaylist('Druhý');
    createPlaylist('Třetí');

    edit(first).rename('Přejmenovaný');
    notifier.reorderPlaylists(2, 0);

    expect(container.read(playlistsProvider).map((playlist) => playlist.name), ['Přejmenovaný', 'Třetí', 'Druhý']);

    edit(container.read(playlistsProvider).first).remove();

    expect(container.read(playlistsProvider).map((playlist) => playlist.name), ['Třetí', 'Druhý']);
  });

  test('add records', () {
    final newPlaylist = createPlaylist('Mše');

    edit(newPlaylist).addSongLyric(songLyric(1));
    edit(newPlaylist).addUserText(const UserText(name: 'Ohlášky', content: 'text'));
    edit(
      newPlaylist,
    ).addBiblePassage(const BiblePassage(book: 18, chapter: 23, startVerse: 1, text: 'Hospodin je můj pastýř'));
    // inserted after first record
    edit(newPlaylist).addSongLyric(songLyric(2), afterRank: 0);
    // duplicate is ignored
    edit(newPlaylist).addSongLyric(songLyric(1));

    expect(records(playlist(newPlaylist.id)), [
      'Ať srdce mé tebe vídá',
      'Bože, chválí tebe',
      'Ohlášky',
      'Žalmy 23:1',
    ]);
  });

  // records of playlist loaded from store are not in order of their ranks after reordering
  test('record added after another keeps order of reordered records', () {
    final store = container.read(appDependenciesProvider).store;
    final newPlaylist = createPlaylist('Mše');

    edit(newPlaylist).addSongLyric(songLyric(1));
    edit(newPlaylist).addSongLyric(songLyric(2));

    // song lyric 2 is moved to the top
    store.box<PlaylistRecord>().putMany([
      for (final playlistRecord in playlist(newPlaylist.id).records)
        playlistRecord.copyWith(rank: playlistRecord.songLyric.targetId == 2 ? 0 : 1),
    ]);

    edit(playlist(newPlaylist.id)).addUserText(const UserText(name: 'Ohlášky', content: 'text'), afterRank: 0);

    expect(records(playlist(newPlaylist.id)), [songLyric(2).name, 'Ohlášky', songLyric(1).name]);
  });

  test('removing record removes its custom text', () {
    final newPlaylist = createPlaylist('Mše');

    edit(newPlaylist).addUserText(const UserText(name: 'Ohlášky', content: 'text'));

    final playlistRecord = playlist(newPlaylist.id).records.single;
    final store = container.read(appDependenciesProvider).store;

    expect(store.box<UserText>().get(playlistRecord.userText.targetId), isNotNull);

    edit(newPlaylist).removeRecord(playlistRecord);

    expect(store.box<PlaylistRecord>().get(playlistRecord.id), isNull);
    expect(store.box<UserText>().get(playlistRecord.userText.targetId), isNull);
  });

  test('duplicated playlist has own custom texts', () {
    final original = createPlaylist('Mše');

    edit(original).addSongLyric(songLyric(1));
    edit(original).addUserText(const UserText(name: 'Ohlášky', content: 'text'));

    final duplicate = edit(original).duplicate('Mše (kopie)');

    expect(records(playlist(duplicate.id)), records(playlist(original.id)));

    final originalUserText = sortedRecords(playlist(original.id)).last.userText.targetId;
    final duplicatedUserText = sortedRecords(playlist(duplicate.id)).last.userText.targetId;

    expect(duplicatedUserText, isNot(originalUserText));
  });

  test('shared playlist is accepted with song lyric settings', () {
    final original = createPlaylist('Mše');

    edit(original).addSongLyric(songLyric(1));
    edit(original).addUserText(const UserText(name: 'Ohlášky', content: 'text'));
    edit(
      original,
    ).addBiblePassage(const BiblePassage(book: 18, chapter: 23, startVerse: 1, endVerse: 2, text: 'Hospodin'));

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

  // files are shared between different versions of the apps, so their keys must not change
  test('shared playlist from previous versions is accepted', () {
    final accepted = notifier.acceptPlaylist(
      jsonDecode(
        '{"name":"Mše","records":['
        '{"rank":0,"song_lyric":{"id":1,"accidentals":null,"transposition":2}},'
        '{"rank":1,"custom_text":{"name":"Ohlášky","content":"text"}},'
        '{"rank":2,"bible_verse":{"book":18,"chapter":23,"start_verse":1,"end_verse":2,"text":"Hospodin"}}]}',
      ),
      'Přijatý',
    );

    expect(records(playlist(accepted.id)), [songLyric(1).name, 'Ohlášky', endsWith('23:1-2')]);
    expect(container.read(songLyricSettingsProvider(1)).transposition, 2);
  });

  test('toggle favorite', () {
    notifier.toggleFavorite(songLyric(1));

    expect(songLyric(1).isFavorite, isTrue);
    expect(records(container.read(favoritePlaylistProvider)), ['Ať srdce mé tebe vídá']);

    notifier.toggleFavorite(songLyric(1));

    expect(songLyric(1).isFavorite, isFalse);
  });
}
