import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/utils/beans.dart';

class Song {
  @PrimaryKey()
  final int id;

  final String name;

  @HasMany(SongLyricBean)
  List<SongLyric> songLyrics;

  Song({
    this.id,
    this.name,
  });

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        id: int.parse(json['id']),
        name: json['name'],
      )..songLyrics = [];
}
