import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:zpevnik/models/entities/author.dart';
import 'package:zpevnik/utils/beans.dart';

class External {
  @PrimaryKey()
  final int id;

  final String name;

  @Column(isNullable: true)
  final String mediaId;

  @BelongsTo(SongLyricBean)
  int songLyricId;

  @ManyToMany(AuthorExternalBean, AuthorBean)
  List<Author> authors;

  External({
    this.id,
    this.name,
    this.mediaId,
  });

  factory External.fromJson(Map<String, dynamic> json) => External(
        id: int.parse(json['id']),
        name: json['public_name'],
        mediaId: json['media_id'],
      )..authors = (json['authors'] as List<dynamic>)
          .map((json) => Author.fromJson(json))
          .toList();
}
