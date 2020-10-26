import 'package:jaguar_orm/jaguar_orm.dart';

import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/utils/beans.dart';

class Songbook {
  @PrimaryKey()
  final int id;

  final String name;
  final String shortcut;
  final String color;
  final bool isPrivate;

  @ManyToMany(SongbookRecordBean, SongLyricBean)
  List<SongLyric> songLyrics;

  Songbook({
    this.id,
    this.name,
    this.shortcut,
    this.color,
    this.isPrivate,
  });
}
