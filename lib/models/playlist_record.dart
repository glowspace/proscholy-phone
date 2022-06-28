// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/playlist.dart';

@Entity()
class PlaylistRecord {
  int id = 0;

  int rank;

  final songLyric = ToOne<SongLyric>();
  final playlist = ToOne<Playlist>();

  PlaylistRecord(this.rank);

  static int nextRank(Store store, Playlist playlist) {
    final query = store.box<PlaylistRecord>().query(PlaylistRecord_.playlist.equals(playlist.id));
    query.order(PlaylistRecord_.rank);

    final rank = query.build().findFirst()?.rank ?? 0;

    return rank + 1;
  }

  PlaylistRecord copyWith({Playlist? playlist}) {
    final playlistRecord = PlaylistRecord(rank)
      ..playlist.target = playlist
      ..songLyric.target = songLyric.target;

    return playlistRecord;
  }

  @override
  String toString() =>
      'PlaylistRecord(id: $id, rank: $rank, songLyric: ${songLyric.targetId}, playlist: ${playlist.targetId})';
}
