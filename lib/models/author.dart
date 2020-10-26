import 'package:jaguar_orm/jaguar_orm.dart';

import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/utils/beans.dart';

class Author {
  @PrimaryKey()
  final int id;

  final String name;

  @ManyToMany(SongLyricAuthorBean, SongLyricBean)
  List<SongLyric> songLyrics;

  Author({
    this.id,
    this.name,
  });
}
