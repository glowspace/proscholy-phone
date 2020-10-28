import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/utils/beans.dart';

class TagEntity {
  @PrimaryKey()
  final int id;
  final String name;
  final int type;

  @ManyToMany(SongLyricTagBean, SongLyricBean)
  List<SongLyricEntity> songLyrics;

  TagEntity({
    this.id,
    this.name,
    this.type,
  });

  factory TagEntity.fromJson(Map<String, dynamic> json) => TagEntity(
        id: int.parse(json['id']),
        name: json['name'],
        type: TagTypeExtension.fromString(json['type_enum']).rawValue,
      );
}
