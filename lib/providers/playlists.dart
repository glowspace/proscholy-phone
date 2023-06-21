import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/playlist_record.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/app_dependencies.dart';
import 'package:zpevnik/providers/utils.dart';

part 'playlists.g.dart';

@riverpod
Playlist favoritePlaylist(FavoritePlaylistRef ref) {
  final box = ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store)).box<Playlist>();

  if (!box.contains(favoritesPlaylistId)) {
    box.put(Playlist.favorites());
  }

  return box.get(favoritesPlaylistId)!;
}

@riverpod
class Playlists extends _$Playlists {
  Box<Playlist> get _playlistsBox {
    return ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store)).box<Playlist>();
  }

  Box<PlaylistRecord> get _playlistRecordsBox {
    return ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store)).box<PlaylistRecord>();
  }

  late int _nextPlaylistId;
  late int _nextPlaylistRecordId;

  @override
  List<Playlist> build() {
    // initialize next ids needed when creating new objects
    _nextPlaylistId = nextId(ref, Playlist_.id);
    _nextPlaylistRecordId = nextId(ref, PlaylistRecord_.id);

    final playlists = queryStore(ref, condition: Playlist_.id.notEquals(favoritesPlaylistId), orderBy: Playlist_.rank);

    return playlists;
  }

  Playlist createPlaylist(String name, {List<SongLyric> songLyrics = const []}) {
    final newPlaylist = Playlist(id: _nextPlaylistId++, name: name, rank: 0, records: ToMany());

    int nextPlaylistRecordRank = 0;

    final newPlaylistRecords = [
      for (final songLyric in songLyrics)
        PlaylistRecord(
          id: _nextPlaylistRecordId++,
          rank: nextPlaylistRecordRank++,
          songLyric: ToOne(target: songLyric),
          playlist: ToOne(target: newPlaylist),
        )
    ];

    // increase rank of all existing playlists and save them
    state = [newPlaylist, for (final playlist in state) playlist.copyWith(rank: playlist.rank + 1)];

    _playlistsBox.putMany(state);
    _playlistRecordsBox.putMany(newPlaylistRecords);

    return newPlaylist;
  }

  Playlist duplicatePlaylist(Playlist playlist, String name) {
    // copy the records with new playlist id
    final playlistRecords = playlist.records
        .map((playlistRecord) => playlistRecord.copyWith(
              id: _nextPlaylistRecordId++,
              playlist: ToOne(targetId: _nextPlaylistId),
            ))
        .toList();

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

  void renamePlaylist(Playlist playlistToRename, String name) {
    final renamedPlaylist = playlistToRename.copyWith(name: name);

    state = [
      for (final playlist in state)
        if (playlist == playlistToRename) renamedPlaylist else playlist
    ];

    _playlistsBox.put(renamedPlaylist);
  }

  void removePlaylist(Playlist playlistToRemove) {
    state = [
      for (final playlist in state)
        if (playlist != playlistToRemove) playlist
    ];

    _playlistsBox.remove(playlistToRemove.id);
  }

  void addToPlaylist(Playlist playlist, SongLyric songLyric, {int? nextRank}) {
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
      playlist: ToOne(target: playlist),
    );

    _playlistRecordsBox.put(playlistRecord);
  }

  void removeFromPlaylist(Playlist playlist, SongLyric songLyric) {
    final playlistRecord =
        playlist.records.firstWhereOrNull((playlistRecord) => playlistRecord.songLyric.targetId == songLyric.id);

    if (playlistRecord != null) _playlistRecordsBox.remove(playlistRecord.id);
  }
}
