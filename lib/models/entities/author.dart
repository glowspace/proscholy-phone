import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:zpevnik/models/entities/external.dart';
import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/utils/beans.dart';

class Author {
  @PrimaryKey()
  final int id;

  final String name;

  @ManyToMany(SongLyricAuthorBean, SongLyricBean)
  List<SongLyricEntity> songLyrics;

  @ManyToMany(AuthorExternalBean, ExternalBean)
  List<External> externals;

  Author({
    this.id,
    this.name,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: int.parse(json['id']),
        name: json['name'],
      );
}
