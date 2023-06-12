import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/identifiable.dart';
import 'package:zpevnik/models/playlist_record.dart';

part 'playlist.freezed.dart';

const favoritesPlaylistId = 1;
const _favoritesName = 'Písně s hvězdičkou';

@freezed
class Playlist with _$Playlist implements Identifiable {
  const Playlist._();

  @Entity(realClass: Playlist)
  const factory Playlist({
    @Id(assignable: true) required int id,
    @Unique(onConflict: ConflictStrategy.fail) required String name,
    required int rank,
    @Backlink() required ToMany<PlaylistRecord> playlistRecords,
  }) = _Playlist;

  factory Playlist.favorites() => Playlist(
        id: favoritesPlaylistId,
        name: _favoritesName,
        rank: 0,
        playlistRecords: ToMany(),
      );

  bool get isFavorites => id == favoritesPlaylistId;
}
