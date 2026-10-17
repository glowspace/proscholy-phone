import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proscholy_common/models/bible_passage.dart';
import 'package:proscholy_common/models/user_text.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/playlist_record.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/bible_passage.dart';
import 'package:proscholy_common/providers/user_text.dart';
import 'package:proscholy_common/providers/settings.dart';
import 'package:proscholy_common/providers/utils.dart';

part 'generated/playlists.g.dart';

@riverpod
Playlist? playlist(Ref ref, int id) {
  if (id == 0) return null;

  final store = ref.read(appDependenciesProvider).store;
  final box = store.box<Playlist>();

  // records are watched too, so they are up to date
  final subscriptions = [
    box.query(Playlist_.id.equals(id)).watch().listen((_) => ref.invalidateSelf()),
    store.box<PlaylistRecord>().query(PlaylistRecord_.playlist.equals(id)).watch().listen((_) => ref.invalidateSelf()),
  ];

  ref.onDispose(() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
  });

  return box.get(id);
}

@Riverpod(keepAlive: true)
Playlist favoritePlaylist(Ref ref) {
  final box = ref.read(appDependenciesProvider).store.box<Playlist>();

  if (!box.contains(favoritesPlaylistId)) box.put(Playlist.favorites());

  return box.get(favoritesPlaylistId)!;
}

@Riverpod(keepAlive: true)
class Playlists extends _$Playlists {
  Box<Playlist> get _playlistsBox => ref.read(appDependenciesProvider).store.box<Playlist>();
  Box<PlaylistRecord> get _playlistRecordsBox => ref.read(appDependenciesProvider).store.box<PlaylistRecord>();
  Box<BiblePassage> get _biblePassageBox => ref.read(appDependenciesProvider).store.box<BiblePassage>();
  Box<UserText> get _userTextBox => ref.read(appDependenciesProvider).store.box<UserText>();

  late int _nextPlaylistId;
  late int _nextPlaylistRecordId;

  late int _nextBiblePassageId;
  late int _nextUserTextId;

  @override
  List<Playlist> build() {
    // favorite playlist must exist before next id is found, otherwise new playlist would get its id
    ref.read(favoritePlaylistProvider);

    // initialize next ids needed when creating new objects
    _nextPlaylistId = nextId(ref, Playlist_.id);
    _nextPlaylistRecordId = nextId(ref, PlaylistRecord_.id);
    _nextBiblePassageId = nextId(ref, BiblePassage_.id);
    _nextUserTextId = nextId(ref, UserText_.id);

    final playlists = queryStore(ref, condition: Playlist_.id.notEquals(favoritesPlaylistId), orderBy: Playlist_.rank);

    // TODO: remove this, it is just to fix errors during testflight
    _playlistRecordsBox.removeMany(
      _playlistRecordsBox.query(PlaylistRecord_.playlist.equals(0)).build().property(PlaylistRecord_.id).find(),
    );

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
      final biblePassage = ref.read(biblePassageProvider(playlistRecord.biblePassage.targetId));
      final userText = ref.read(userTextProvider(playlistRecord.userText.targetId));

      if (biblePassage != null) {
        final duplicatedBiblePassage = biblePassage.copyWith(id: _nextBiblePassageId++);

        _biblePassageBox.put(duplicatedBiblePassage);

        playlistRecords.add(
          playlistRecord.copyWith(
            id: _nextPlaylistRecordId++,
            biblePassage: ToOne(target: duplicatedBiblePassage),
          ),
        );
      } else if (userText != null) {
        final duplicatedUserText = userText.copyWith(id: _nextUserTextId++);

        _userTextBox.put(duplicatedUserText);

        playlistRecords.add(
          playlistRecord.copyWith(
            id: _nextPlaylistRecordId++,
            userText: ToOne(target: duplicatedUserText),
          ),
        );
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
    final playlistRecords = <PlaylistRecord>[];

    for (final playlistRecordData in playlistData['records']) {
      final playlistRecord = PlaylistRecord(
        id: _nextPlaylistRecordId++,
        rank: playlistRecordData['rank'],
        songLyric: ToOne(targetId: playlistRecordData['song_lyric']?['id']),
        userText: ToOne(
          target: playlistRecordData.containsKey('custom_text')
              ? createUserText(
                  name: playlistRecordData['custom_text']['name'],
                  content: playlistRecordData['custom_text']['content'],
                )
              : null,
        ),
        biblePassage: ToOne(
          target: playlistRecordData.containsKey('bible_verse')
              ? createBiblePassage(
                  book: playlistRecordData['bible_verse']['book'],
                  chapter: playlistRecordData['bible_verse']['chapter'],
                  startVerse: playlistRecordData['bible_verse']['start_verse'],
                  endVerse: playlistRecordData['bible_verse']['end_verse'],
                  text: playlistRecordData['bible_verse']['text'],
                )
              : null,
        ),
        playlist: ToOne(targetId: _nextPlaylistId),
      );

      if (playlistRecordData['song_lyric']?.containsKey('accidentals') ?? false) {
        final settingsNotifier = ref.read(songLyricSettingsProvider(playlistRecordData['song_lyric']['id']).notifier);
        if (playlistRecordData['song_lyric']['accidentals'] != null) {
          settingsNotifier.changeAccidentals(playlistRecordData['song_lyric']['accidentals']);
        }
        settingsNotifier.setTransposition(playlistRecordData['song_lyric']['transposition']);
      }

      playlistRecords.add(playlistRecord);
    }

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
      final biblePassage = ref.read(biblePassageProvider(playlistRecord.biblePassage.targetId));
      final userText = ref.read(userTextProvider(playlistRecord.userText.targetId));
      final songLyricSettings = ref.read(songLyricSettingsProvider(playlistRecord.songLyric.targetId));

      final record = {
        'rank': playlistRecord.rank,
        if (playlistRecord.songLyric.targetId != 0)
          'song_lyric': {
            'id': playlistRecord.songLyric.targetId,
            if (songLyricSettings.id != 0) ...{
              'accidentals': songLyricSettings.accidentals,
              'transposition': songLyricSettings.transposition,
            },
          },
        if (biblePassage != null)
          'bible_verse': {
            'book': biblePassage.book,
            'chapter': biblePassage.chapter,
            'start_verse': biblePassage.startVerse,
            'end_verse': biblePassage.endVerse,
            'text': biblePassage.text,
          },
        if (userText != null)
          'custom_text': {
            'name': userText.name,
            'content': userText.content,
          },
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
        if (playlist == playlistToRename) renamedPlaylist else playlist,
    ];

    _playlistsBox.put(renamedPlaylist);

    return renamedPlaylist;
  }

  void removePlaylist(Playlist playlistToRemove) {
    state = [
      for (final playlist in state)
        if (playlist.id != playlistToRemove.id) playlist,
    ];

    // remove records first, as they might not be loaded and if we remove playlist first, it won't be possible to load them anymore
    _playlistRecordsBox.removeMany(playlistToRemove.records.map((playlistRecord) => playlistRecord.id).toList());
    _playlistsBox.remove(playlistToRemove.id);

    // delete this with delay, so it does not lead to exceptions when poping from playlist screen
    Future.delayed(const Duration(seconds: 1), () {
      _userTextBox.removeMany(
        playlistToRemove.records
            .map((playlistRecord) => playlistRecord.userText.targetId)
            .where((id) => id != 0)
            .toList(),
      );
      _biblePassageBox.removeMany(
        playlistToRemove.records
            .map((playlistRecord) => playlistRecord.biblePassage.targetId)
            .where((id) => id != 0)
            .toList(),
      );
    });
  }

  void addToPlaylist(
    Playlist playlist, {
    SongLyric? songLyric,
    UserText? userText,
    BiblePassage? biblePassage,
    int? afterRank,
  }) {
    // prevent duplicates
    if (playlist.records.any(
      (playlistRecord) =>
          playlistRecord.songLyric.targetId == songLyric?.id ||
          playlistRecord.userText.targetId == userText?.id ||
          playlistRecord.biblePassage.targetId == biblePassage?.id,
    )) {
      return;
    }

    // first find next rank
    final queryBuilder = _playlistRecordsBox.query(PlaylistRecord_.playlist.equals(playlist.id));

    queryBuilder.order(PlaylistRecord_.rank, flags: Order.descending);

    final query = queryBuilder.build();
    final lastRank = afterRank ?? query.findFirst()?.rank ?? -1;

    query.close();

    final playlistRecord = PlaylistRecord(
      id: _nextPlaylistRecordId++,
      rank: lastRank + 1,
      songLyric: ToOne(target: songLyric),
      userText: ToOne(target: userText),
      biblePassage: ToOne(target: biblePassage),
      playlist: ToOne(target: playlist),
    );

    if (afterRank != null) {
      // records loaded from store are not ordered by their ranks
      playlist.records.sort((a, b) => a.rank.compareTo(b.rank));
      playlist.records.insert(afterRank + 1, playlistRecord);

      final playlistRecords = playlist.records
          .mapIndexed((i, playlistRecord) => playlistRecord.copyWith(rank: i))
          .toList();

      playlist.records.clear();
      playlist.records.addAll(playlistRecords);

      _playlistRecordsBox.putMany(playlistRecords);
    } else {
      _playlistRecordsBox.put(playlistRecord);

      playlist.records.add(playlistRecord);
    }

    songLyric?.playlistRecords.add(playlistRecord);
  }

  void removeFromPlaylist(Playlist playlist, PlaylistRecord playlistRecordToRemove) {
    _playlistRecordsBox.remove(playlistRecordToRemove.id);

    playlist.records.removeWhere((playlistRecord) => playlistRecord.id == playlistRecordToRemove.id);

    if (playlistRecordToRemove.userText.targetId != 0) {
      _userTextBox.remove(playlistRecordToRemove.userText.targetId);
    } else if (playlistRecordToRemove.biblePassage.targetId != 0) {
      _biblePassageBox.remove(playlistRecordToRemove.biblePassage.targetId);
    }
  }

  void toggleFavorite(SongLyric songLyric) {
    final favoritePlaylist = ref.read(favoritePlaylistProvider);

    if (songLyric.isFavorite) {
      final playlistRecordToRemove = favoritePlaylist.records.firstWhereOrNull(
        (playlistRecord) => playlistRecord.songLyric.targetId == songLyric.id,
      );

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

  BiblePassage createBiblePassage({
    required int book,
    required int chapter,
    required int startVerse,
    int? endVerse,
    required String text,
  }) {
    final biblePassage = BiblePassage(
      id: _nextBiblePassageId++,
      book: book,
      chapter: chapter,
      startVerse: startVerse,
      endVerse: endVerse,
      text: text,
    );

    _biblePassageBox.put(biblePassage);

    return biblePassage;
  }

  UserText createUserText({required String name, required String content}) {
    final userText = UserText(
      id: _nextUserTextId++,
      name: name,
      content: content,
    );

    _userTextBox.put(userText);

    return userText;
  }
}
