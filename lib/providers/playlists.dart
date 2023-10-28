import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/models/bible_verse.dart';
import 'package:zpevnik/models/custom_text.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/playlist_record.dart';
import 'package:zpevnik/models/settings.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/app_dependencies.dart';
import 'package:zpevnik/providers/bible_verse.dart';
import 'package:zpevnik/providers/custom_text.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/providers/utils.dart';

part 'playlists.g.dart';

@Riverpod(keepAlive: true)
Playlist favoritePlaylist(FavoritePlaylistRef ref) {
  final box = ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store.box<Playlist>()));

  if (!box.contains(favoritesPlaylistId)) box.put(Playlist.favorites());

  return box.get(favoritesPlaylistId)!;
}

@Riverpod(keepAlive: true)
class Playlists extends _$Playlists {
  Box<Playlist> get _playlistsBox {
    return ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store.box<Playlist>()));
  }

  Box<PlaylistRecord> get _playlistRecordsBox {
    return ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store.box<PlaylistRecord>()));
  }

  Box<BibleVerse> get _bibleVerseBox {
    return ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store.box<BibleVerse>()));
  }

  Box<CustomText> get _customTextBox {
    return ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store.box<CustomText>()));
  }

  late int _nextPlaylistId;
  late int _nextPlaylistRecordId;

  late int _nextBibleVerseId;
  late int _nextCustomTextId;

  @override
  List<Playlist> build() {
    // initialize next ids needed when creating new objects
    _nextPlaylistId = nextId(ref, Playlist_.id);
    _nextPlaylistRecordId = nextId(ref, PlaylistRecord_.id);
    _nextBibleVerseId = nextId(ref, BibleVerse_.id);
    _nextCustomTextId = nextId(ref, CustomText_.id);

    final playlists = queryStore(ref, condition: Playlist_.id.notEquals(favoritesPlaylistId), orderBy: Playlist_.rank);

    return playlists;
  }

  Playlist createPlaylist(String name) {
    final newPlaylist = Playlist(
      id: _nextPlaylistId++,
      name: name,
      rank: 0,
      records: ToMany(),
    );

    // increase rank of all existing playlists and save them
    state = [newPlaylist, for (final playlist in state) playlist.copyWith(rank: playlist.rank + 1)];

    _playlistsBox.putMany(state);

    return newPlaylist;
  }

  Playlist duplicatePlaylist(Playlist playlist, String name) {
    // copy the records with new playlist id
    final playlistRecords = <PlaylistRecord>[];

    // for bible verses and custom texts make also duplicates, so that changes in duplicated playlist don't alter records in previous
    for (final playlistRecord in playlist.records) {
      final bibleVerse = ref.read(bibleVerseProvider(playlistRecord.bibleVerse.targetId));
      final customText = ref.read(customTextProvider(playlistRecord.customText.targetId));

      if (bibleVerse != null) {
        final duplicatedBibleVerse = bibleVerse.copyWith(id: _nextBibleVerseId++);

        _bibleVerseBox.put(duplicatedBibleVerse);

        playlistRecords
            .add(playlistRecord.copyWith(id: _nextPlaylistRecordId++, bibleVerse: ToOne(target: duplicatedBibleVerse)));
      } else if (customText != null) {
        final duplicatedCustomText = customText.copyWith(id: _nextCustomTextId++);

        _customTextBox.put(duplicatedCustomText);

        playlistRecords
            .add(playlistRecord.copyWith(id: _nextPlaylistRecordId++, customText: ToOne(target: duplicatedCustomText)));
      } else {
        playlistRecords.add(playlistRecord.copyWith(id: _nextPlaylistRecordId++));
      }
    }

    final newPlaylist = playlist.copyWith(
      id: _nextPlaylistId++,
      name: name,
      rank: 0,
      records: ToMany(items: playlistRecords),
    );

    // increase rank of all existing playlists and save them
    state = [newPlaylist, for (final playlist in state) playlist.copyWith(rank: playlist.rank + 1)];

    _playlistsBox.putMany(state);

    return newPlaylist;
  }

  Playlist acceptPlaylist(Map<String, dynamic> playlistData, String name) {
    final playlistRecords = [
      for (final playlistRecordData in playlistData['records'])
        PlaylistRecord(
          id: _nextPlaylistRecordId++,
          rank: playlistRecordData['rank'],
          songLyric: ToOne(
            targetId: playlistRecordData.containsKey('song_lyric') ? playlistRecordData['song_lyric']['id'] : 0,
          ),
          customText: ToOne(
            target: playlistRecordData.containsKey('custom_text')
                ? CustomText(
                    id: _nextCustomTextId++,
                    name: playlistRecordData['custom_text']['name'],
                    content: playlistRecordData['custom_text']['content'],
                  )
                : null,
          ),
          bibleVerse: ToOne(
            target: playlistRecordData.containsKey('bible_verse')
                ? BibleVerse(
                    id: _nextBibleVerseId++,
                    book: playlistRecordData['bible_verse']['book'],
                    chapter: playlistRecordData['bible_verse']['chapter'],
                    startVerse: playlistRecordData['bible_verse']['start_verse'],
                    endVerse: playlistRecordData['bible_verse']['end_verse'],
                    text: playlistRecordData['bible_verse']['text'],
                  )
                : null,
          ),
          playlist: ToOne(targetId: _nextPlaylistId),
          settings: ToOne(
            target: (playlistRecordData['accidentals'] != null || playlistRecordData['transposition'] != 0)
                ? SongLyricSettingsModel.defaultFromGlobalSettings(ref.read(settingsProvider)).copyWith(
                    id: nextId(ref, SongLyricSettingsModel_.id),
                    accidentals: playlistRecordData['accidentals'],
                    transposition: playlistRecordData['transposition'],
                  )
                : null,
          ),
        )
    ];

    final newPlaylist = Playlist(
      id: _nextPlaylistId++,
      name: name,
      rank: 0,
      records: ToMany(items: playlistRecords),
    );

    // increase rank of all existing playlists and save them
    state = [newPlaylist, for (final playlist in state) playlist.copyWith(rank: playlist.rank + 1)];

    _playlistsBox.putMany(state);
    _playlistRecordsBox.putMany(playlistRecords);

    return newPlaylist;
  }

  // TODO: move this to some better place, it is here just to correspond to `acceptPlaylist` function above
  Map<String, dynamic> playlistToMap(Playlist playlist) {
    final records = <Map<String, dynamic>>[];

    for (final playlistRecord in playlist.records) {
      final bibleVerse = ref.read(bibleVerseProvider(playlistRecord.bibleVerse.targetId));
      final customText = ref.read(customTextProvider(playlistRecord.customText.targetId));

      final record = {
        'rank': playlistRecord.rank,
        'song_lyric': playlistRecord.songLyric.targetId,
        if (bibleVerse != null)
          'bible_verse': {
            'book': bibleVerse.book,
            'chapter': bibleVerse.chapter,
            'start_verse': bibleVerse.startVerse,
            'end_verse': bibleVerse.endVerse,
            'text': bibleVerse.text,
          },
        if (customText != null)
          'custom_text': {
            'name': customText.name,
            'content': customText.content,
          },
        if (playlistRecord.settings.targetId != 0) 'accidentals': playlistRecord.settings.target!.accidentals,
        if (playlistRecord.settings.targetId != 0) 'transposition': playlistRecord.settings.target!.transposition,
      };

      records.add(record);
    }

    return {
      'name': playlist.name,
      'records': records,
    };
  }

  Playlist renamePlaylist(Playlist playlistToRename, String name) {
    final renamedPlaylist = playlistToRename.copyWith(name: name);

    state = [
      for (final playlist in state)
        if (playlist == playlistToRename) renamedPlaylist else playlist
    ];

    _playlistsBox.put(renamedPlaylist);

    return renamedPlaylist;
  }

  void removePlaylist(Playlist playlistToRemove) {
    state = [
      for (final playlist in state)
        if (playlist.id != playlistToRemove.id) playlist
    ];

    _playlistsBox.remove(playlistToRemove.id);
    _playlistRecordsBox.removeMany(playlistToRemove.records.map((playlistRecord) => playlistRecord.id).toList());

    _customTextBox.removeMany(playlistToRemove.records
        .map((playlistRecord) => playlistRecord.customText.targetId)
        .where((id) => id != 0)
        .toList());
    _bibleVerseBox.removeMany(playlistToRemove.records
        .map((playlistRecord) => playlistRecord.bibleVerse.targetId)
        .where((id) => id != 0)
        .toList());
  }

  void addToPlaylist(
    Playlist playlist, {
    SongLyric? songLyric,
    CustomText? customText,
    BibleVerse? bibleVerse,
    int? nextRank,
  }) {
    // prevent duplicates
    if (playlist.records.any((playlistRecord) =>
        playlistRecord.songLyric.targetId == songLyric?.id ||
        playlistRecord.customText.targetId == customText?.id ||
        playlistRecord.bibleVerse.targetId == bibleVerse?.id)) return;

    // first find next rank
    final queryBuilder = _playlistRecordsBox.query(PlaylistRecord_.playlist.equals(playlist.id));

    queryBuilder.order(PlaylistRecord_.rank, flags: Order.descending);

    final query = queryBuilder.build();
    final lastRank = query.findFirst()?.rank ?? -1;

    query.close();

    final playlistRecord = PlaylistRecord(
      id: _nextPlaylistRecordId++,
      rank: lastRank + 1,
      songLyric: ToOne(target: songLyric),
      customText: ToOne(target: customText),
      bibleVerse: ToOne(target: bibleVerse),
      playlist: ToOne(target: playlist),
      settings: ToOne(),
    );

    _playlistRecordsBox.put(playlistRecord);

    playlist.records.add(playlistRecord);
    songLyric?.playlistRecords.add(playlistRecord);
  }

  void removeFromPlaylist(Playlist playlist, PlaylistRecord playlistRecordToRemove) {
    _playlistRecordsBox.remove(playlistRecordToRemove.id);

    playlist.records.removeWhere((playlistRecord) => playlistRecord.id == playlistRecordToRemove.id);

    if (playlistRecordToRemove.customText.targetId != 0) {
      _customTextBox.remove(playlistRecordToRemove.customText.targetId);
    } else if (playlistRecordToRemove.bibleVerse.targetId != 0) {
      _bibleVerseBox.remove(playlistRecordToRemove.bibleVerse.targetId);
    }
  }

  void toggleFavorite(SongLyric songLyric) {
    final favoritePlaylist = ref.read(favoritePlaylistProvider);

    if (songLyric.isFavorite) {
      final playlistRecordToRemove = favoritePlaylist.records
          .firstWhereOrNull((playlistRecord) => playlistRecord.songLyric.targetId == songLyric.id);

      if (playlistRecordToRemove != null) {
        removeFromPlaylist(favoritePlaylist, playlistRecordToRemove);

        songLyric.playlistRecords.removeWhere((playlistRecord) => playlistRecord.id == playlistRecordToRemove.id);
      }
    } else {
      addToPlaylist(favoritePlaylist, songLyric: songLyric);
    }
  }

  void reorderPlaylists(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;

    final playlists = state;

    playlists.insert(newIndex, playlists.removeAt(oldIndex));

    state = playlists.mapIndexed((index, playlist) => playlist.copyWith(rank: index)).toList();

    _playlistsBox.putMany(state);
  }

  BibleVerse createBibleVerse({
    required int book,
    required int chapter,
    required int startVerse,
    int? endVerse,
    required String text,
  }) {
    final bibleVerse = BibleVerse(
      id: _nextBibleVerseId++,
      book: book,
      chapter: chapter,
      startVerse: startVerse,
      endVerse: endVerse,
      text: text,
    );

    _bibleVerseBox.put(bibleVerse);

    return bibleVerse;
  }

  CustomText createCustomText({required String name, required String content}) {
    final customText = CustomText(
      id: _nextCustomTextId++,
      name: name,
      content: content,
    );

    _customTextBox.put(customText);

    return customText;
  }
}
