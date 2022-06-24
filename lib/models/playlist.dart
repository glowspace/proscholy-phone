import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/playlist_record.dart';
import 'package:zpevnik/models/song_lyric.dart';

const favoritesPlaylistId = 1;
const _favoritesName = 'Písně s hvězdičkou';

@Entity()
class Playlist {
  int id = 0;

  final String name;

  @Backlink()
  final playlistRecords = ToMany<PlaylistRecord>();

  Playlist(this.name);

  Playlist.favorite()
      : id = favoritesPlaylistId,
        name = _favoritesName;

  static List<Playlist> load(Store store) {
    return store.box<Playlist>().query(Playlist_.id.notEquals(favoritesPlaylistId)).build().find();
  }

  static Playlist loadFavorites(Store store) {
    return store.box<Playlist>().get(favoritesPlaylistId)!;
  }

  bool get isFavorites => id == favoritesPlaylistId;

  List<SongLyric> get songLyrics => playlistRecords.map((playlistRecord) => playlistRecord.songLyric.target!).toList();

  void addSongLyric(SongLyric songLyric, int rank) {
    if (playlistRecords.any((playlistRecord) => playlistRecord.songLyric.target == songLyric)) return;

    final playlistRecord = PlaylistRecord(rank)
      ..playlist.target = this
      ..songLyric.target = songLyric;

    playlistRecords.add(playlistRecord);
    playlistRecords.applyToDb();

    songLyric.playlistRecords.add(playlistRecord);
  }

  void removeSongLyric(SongLyric songLyric) {
    playlistRecords.removeWhere((playlistRecord) => playlistRecord.songLyric.target == songLyric);
    playlistRecords.applyToDb();

    songLyric.playlistRecords.removeWhere((playlistRecord) => playlistRecord.songLyric.target == songLyric);
  }

  @override
  String toString() => 'Playlist(id: $id, name: $name)';
}
