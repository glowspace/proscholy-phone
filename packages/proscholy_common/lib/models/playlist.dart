import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:proscholy_common/models/model.dart';
import 'package:proscholy_common/models/playlist_record.dart';
import 'package:proscholy_common/models/tag.dart';

part 'generated/playlist.freezed.dart';

const favoritesPlaylistId = 1;
const _favoritesName = 'Písně s hvězdičkou';

@freezed
sealed class Playlist with _$Playlist implements Identifiable, RecentItem, SongsList {
  const Playlist._();

  @Entity(realClass: Playlist)
  const factory Playlist({
    @Id(assignable: true) required int id,
    @Unique(onConflict: ConflictStrategy.fail) required String name,
    required int rank,
    @Backlink() required ToMany<PlaylistRecord> records,
  }) = _Playlist;

  // its id is set when it is added to playlists
  factory Playlist.empty(String name) => Playlist(id: 0, name: name, rank: 0, records: ToMany());

  factory Playlist.favorites() => Playlist(
    id: favoritesPlaylistId,
    name: _favoritesName,
    rank: 0,
    records: ToMany(),
  );

  Tag get tag => Tag.fromPlaylist(this);

  bool get isFavorites => id == favoritesPlaylistId;

  @override
  String get displayName => name;

  @override
  RecentItemType get recentItemType => RecentItemType.playlist;

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Playlist && id == other.id && name == other.name;
}
