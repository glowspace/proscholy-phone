import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/utils/beans.dart';

class PlaylistEntity {
  @PrimaryKey()
  final int id;

  String name;
  bool isArchived;

  int orderValue;

  @ManyToMany(SongLyricPlaylistBean, SongLyricBean)
  List<SongLyricEntity> songLyrics;

  PlaylistEntity({
    this.id,
    this.name,
    this.isArchived = false,
    this.orderValue,
  });
}
