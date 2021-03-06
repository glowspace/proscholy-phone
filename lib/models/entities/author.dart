import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:zpevnik/models/entities/entity.dart';
import 'package:zpevnik/models/entities/external.dart';
import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/utils/beans.dart';

class AuthorEntity implements Entity {
  @PrimaryKey()
  final int id;

  final String name;

  @ManyToMany(SongLyricAuthorBean, SongLyricBean)
  List<SongLyricEntity> songLyrics;

  @ManyToMany(AuthorExternalBean, ExternalBean)
  List<ExternalEntity> externals;

  AuthorEntity({
    this.id,
    this.name,
  });

  factory AuthorEntity.fromJson(Map<String, dynamic> json) => AuthorEntity(
        id: int.parse(json['id']),
        name: json['name'],
      );
}
