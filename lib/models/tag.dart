import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/utils/beans.dart';

class Tag {
  @PrimaryKey()
  final int id;
  final String name;
  final int type;

  @ManyToMany(SongLyricTagBean, SongLyricBean)
  List<SongLyric> songLyrics;

  Tag({
    this.id,
    this.name,
    this.type,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: int.parse(json['id']),
        name: json['name'],
        // todo: handle type
        type: 1,
      );
}
