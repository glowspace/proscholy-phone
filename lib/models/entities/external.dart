import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:zpevnik/models/entities/author.dart';
import 'package:zpevnik/utils/beans.dart';

class ExternalEntity {
  @PrimaryKey()
  final int id;

  final String name;

  @Column(isNullable: true)
  final String mediaId;

  @Column(isNullable: true)
  final String mediaType;

  @BelongsTo(SongLyricBean)
  int songLyricId;

  @ManyToMany(AuthorExternalBean, AuthorBean)
  List<AuthorEntity> authors;

  ExternalEntity({this.id, this.name, this.mediaId, this.mediaType});

  factory ExternalEntity.fromJson(Map<String, dynamic> json) => ExternalEntity(
        id: int.parse(json['id']),
        name: json['public_name'],
        mediaId: json['media_id'],
        mediaType: json['media_type'],
      )..authors = (json['authors'] as List<dynamic>).map((json) => AuthorEntity.fromJson(json)).toList();
}
