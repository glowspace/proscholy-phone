import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/utils/beans.dart';

class SongEntity {
  @PrimaryKey()
  final int id;

  final String name;

  @HasMany(SongLyricBean)
  List<SongLyricEntity> songLyrics;

  SongEntity({
    this.id,
    this.name,
  });

  factory SongEntity.fromJson(Map<String, dynamic> json) => SongEntity(
        id: int.parse(json['id']),
        name: json['name'],
      )..songLyrics = [];
}
