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

// playlist with its records, both are watched, so they are up to date, it is null after the playlist was removed
@riverpod
class PlaylistNotifier extends _$PlaylistNotifier {
  Store get _store => ref.read(appDependenciesProvider).store;

  @override
  Playlist? build(int id) {
    if (id == 0) return null;

    final subscriptions = [
      _store.box<Playlist>().query(Playlist_.id.equals(id)).watch().listen((_) => ref.invalidateSelf()),
      _store
          .box<PlaylistRecord>()
          .query(PlaylistRecord_.playlist.equals(id))
          .watch()
          .listen((_) => ref.invalidateSelf()),
    ];

    ref.onDispose(() {
      for (final subscription in subscriptions) {
        subscription.cancel();
      }
    });

    return _store.box<Playlist>().get(id);
  }

  Playlist rename(String name) {
    final renamedPlaylist = state!.copyWith(name: name);

    _store.box<Playlist>().put(renamedPlaylist);

    _changed();

    return renamedPlaylist;
  }

  // bible passages and user texts are copied too, so their changes in one playlist don't change the other one
  Playlist duplicate(String name) {
    return _store.runInTransaction(TxMode.write, () {
      var nextRecordId = nextId(ref, PlaylistRecord_.id);
      final records = <PlaylistRecord>[];

      for (final record in _records()) {
        final userText = record.userText.target;
        final biblePassage = record.biblePassage.target;

        records.add(
          record.copyWith(
            id: nextRecordId++,
            userText: ToOne(target: userText == null ? null : _storeUserText(ref, userText)),
            biblePassage: ToOne(target: biblePassage == null ? null : _storeBiblePassage(ref, biblePassage)),
          ),
        );
      }

      return ref
          .read(playlistsProvider.notifier)
          .addPlaylist(
            state!.copyWith(
              name: name,
              records: ToMany(items: records),
            ),
          );
    });
  }

  // bible passages and user texts of the playlist are removed too
  void remove() {
    final records = _records();

    _store.runInTransaction(TxMode.write, () {
      _store.box<PlaylistRecord>().removeMany([for (final record in records) record.id]);
      _store.box<UserText>().removeMany([
        for (final record in records)
          if (record.userText.targetId != 0) record.userText.targetId,
      ]);
      _store.box<BiblePassage>().removeMany([
        for (final record in records)
          if (record.biblePassage.targetId != 0) record.biblePassage.targetId,
      ]);
      _store.box<Playlist>().remove(id);
    });

    _changed();
  }

  void addSongLyric(SongLyric songLyric, {int? afterRank}) {
    if (_records().any((record) => record.songLyric.targetId == songLyric.id)) return;

    final record = _addRecord(
      PlaylistRecord.songLyric(id: nextId(ref, PlaylistRecord_.id), rank: 0, playlist: state!, songLyric: songLyric),
      afterRank,
    );

    // song lyric is updated without loading it again, e.g. so it is shown as favorite
    songLyric.playlistRecords.add(record);
  }

  // user text that is not stored yet is stored too
  void addUserText(UserText userText, {int? afterRank}) {
    if (_records().any((record) => userText.id != 0 && record.userText.targetId == userText.id)) return;

    _store.runInTransaction(TxMode.write, () {
      _addRecord(
        PlaylistRecord.userText(
          id: nextId(ref, PlaylistRecord_.id),
          rank: 0,
          playlist: state!,
          userText: userText.id == 0 ? _storeUserText(ref, userText) : userText,
        ),
        afterRank,
      );
    });
  }

  // bible passage that is not stored yet is stored too
  void addBiblePassage(BiblePassage biblePassage, {int? afterRank}) {
    if (_records().any((record) => biblePassage.id != 0 && record.biblePassage.targetId == biblePassage.id)) return;

    _store.runInTransaction(TxMode.write, () {
      _addRecord(
        PlaylistRecord.biblePassage(
          id: nextId(ref, PlaylistRecord_.id),
          rank: 0,
          playlist: state!,
          biblePassage: biblePassage.id == 0 ? _storeBiblePassage(ref, biblePassage) : biblePassage,
        ),
        afterRank,
      );
    });
  }

  // bible passage or user text of the record is removed too
  void removeRecord(PlaylistRecord record) {
    _store.runInTransaction(TxMode.write, () {
      _store.box<PlaylistRecord>().remove(record.id);

      if (record.userText.targetId != 0) {
        _store.box<UserText>().remove(record.userText.targetId);
      } else if (record.biblePassage.targetId != 0) {
        _store.box<BiblePassage>().remove(record.biblePassage.targetId);
      }
    });

    _changed();
  }

  // records are read from store, as records of loaded playlist are not up to date after adding or removing some
  List<PlaylistRecord> _records() {
    final queryBuilder = _store.box<PlaylistRecord>().query(PlaylistRecord_.playlist.equals(id))
      ..order(PlaylistRecord_.rank);
    final query = queryBuilder.build();
    final records = query.find();

    query.close();

    return records;
  }

  // record is inserted after record with `afterRank` or as the last one, ranks of all records are updated
  PlaylistRecord _addRecord(PlaylistRecord record, int? afterRank) {
    final records = _records();
    final index = afterRank == null ? records.length : afterRank + 1;

    records.insert(index, record);

    final rankedRecords = records.mapIndexed((rank, record) => record.copyWith(rank: rank)).toList();

    _store.box<PlaylistRecord>().putMany(rankedRecords);

    _changed();

    return rankedRecords[index];
  }

  // changes are notified from store later, so the playlist and playlists are updated now
  void _changed() {
    ref.invalidateSelf();
    ref.invalidate(playlistsProvider);
  }
}

UserText _storeUserText(Ref ref, UserText userText) {
  final storedUserText = userText.copyWith(id: nextId(ref, UserText_.id));

  ref.read(appDependenciesProvider).store.box<UserText>().put(storedUserText);

  return storedUserText;
}

BiblePassage _storeBiblePassage(Ref ref, BiblePassage biblePassage) {
  final storedBiblePassage = biblePassage.copyWith(id: nextId(ref, BiblePassage_.id));

  ref.read(appDependenciesProvider).store.box<BiblePassage>().put(storedBiblePassage);

  return storedBiblePassage;
}

@Riverpod(keepAlive: true)
Playlist favoritePlaylist(Ref ref) {
  final box = ref.read(appDependenciesProvider).store.box<Playlist>();

  if (!box.contains(favoritesPlaylistId)) box.put(Playlist.favorites());

  return box.get(favoritesPlaylistId)!;
}

@Riverpod(keepAlive: true)
class Playlists extends _$Playlists {
  Store get _store => ref.read(appDependenciesProvider).store;

  @override
  List<Playlist> build() {
    // favorite playlist must exist before next id is found, otherwise new playlist would get its id
    ref.read(favoritePlaylistProvider);

    return queryStore(ref, condition: Playlist_.id.notEquals(favoritesPlaylistId), orderBy: Playlist_.rank);
  }

  // playlist is added as the first one
  Playlist addPlaylist(Playlist playlist) {
    final addedPlaylist = playlist.copyWith(id: nextId(ref, Playlist_.id), rank: 0);

    // increase rank of all existing playlists and save them
    state = [addedPlaylist, for (final playlist in state) playlist.copyWith(rank: playlist.rank + 1)];

    _store.box<Playlist>().putMany(state);

    return addedPlaylist;
  }

  Playlist acceptPlaylist(Map<String, dynamic> playlistData, String name) {
    return _store.runInTransaction(TxMode.write, () {
      final playlist = addPlaylist(Playlist.empty(name));
      var nextRecordId = nextId(ref, PlaylistRecord_.id);
      final playlistRecords = <PlaylistRecord>[];

      for (final playlistRecordData in playlistData['records']) {
        final userTextData = playlistRecordData['custom_text'];
        final biblePassageData = playlistRecordData['bible_verse'];

        playlistRecords.add(
          PlaylistRecord(
            id: nextRecordId++,
            rank: playlistRecordData['rank'],
            // song lyric might not be downloaded yet
            songLyric: ToOne(targetId: playlistRecordData['song_lyric']?['id']),
            userText: ToOne(
              target: userTextData == null
                  ? null
                  : _storeUserText(ref, UserText(name: userTextData['name'], content: userTextData['content'])),
            ),
            biblePassage: ToOne(
              target: biblePassageData == null
                  ? null
                  : _storeBiblePassage(
                      ref,
                      BiblePassage(
                        book: biblePassageData['book'],
                        chapter: biblePassageData['chapter'],
                        startVerse: biblePassageData['start_verse'],
                        endVerse: biblePassageData['end_verse'],
                        text: biblePassageData['text'],
                      ),
                    ),
            ),
            playlist: ToOne(target: playlist),
          ),
        );

        if (playlistRecordData['song_lyric']?.containsKey('accidentals') ?? false) {
          final settingsNotifier = ref.read(songLyricSettingsProvider(playlistRecordData['song_lyric']['id']).notifier);
          if (playlistRecordData['song_lyric']['accidentals'] != null) {
            settingsNotifier.changeAccidentals(playlistRecordData['song_lyric']['accidentals']);
          }
          settingsNotifier.setTransposition(playlistRecordData['song_lyric']['transposition']);
        }
      }

      _store.box<PlaylistRecord>().putMany(playlistRecords);

      return playlist;
    });
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

  void toggleFavorite(SongLyric songLyric) {
    final favoritePlaylistNotifier = ref.read(playlistProvider(favoritesPlaylistId).notifier);

    if (songLyric.isFavorite) {
      final query = _store
          .box<PlaylistRecord>()
          .query(
            PlaylistRecord_.playlist.equals(favoritesPlaylistId).and(PlaylistRecord_.songLyric.equals(songLyric.id)),
          )
          .build();
      final playlistRecordToRemove = query.findFirst();

      query.close();

      if (playlistRecordToRemove != null) {
        favoritePlaylistNotifier.removeRecord(playlistRecordToRemove);

        songLyric.playlistRecords.removeWhere((playlistRecord) => playlistRecord.id == playlistRecordToRemove.id);
      }
    } else {
      favoritePlaylistNotifier.addSongLyric(songLyric);
    }
  }

  void reorderPlaylists(int oldIndex, int newIndex) {
    final playlists = state;

    playlists.insert(newIndex, playlists.removeAt(oldIndex));

    state = playlists.mapIndexed((index, playlist) => playlist.copyWith(rank: index)).toList();

    _store.box<Playlist>().putMany(state);
  }
}
