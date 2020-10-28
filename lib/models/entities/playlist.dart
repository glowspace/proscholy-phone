import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/utils/beans.dart';

class Playlist {
  @PrimaryKey()
  final int id;

  final String name;
  final bool isArchived;

  @ManyToMany(SongLyricPlaylistBean, SongLyricBean)
  List<SongLyricEntity> songLyrics;

  Playlist({
    this.id,
    this.name,
    this.isArchived,
  });
}
