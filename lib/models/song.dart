import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/song_lyric.dart';

@Entity()
class Song {
  @Id(assignable: true)
  final int id;

  final String name;

  @Backlink()
  final songLyrics = ToMany<SongLyric>();

  Song(this.id, this.name);

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      int.parse(json['id'] as String),
      json['name'] as String,
    );
  }

  static List<Song> fromMapList(Map<String, dynamic> json) {
    return (json['songs'] as List).map((json) => Song.fromJson(json)).toList();
  }

  @override
  String toString() => 'Song(id: $id, name: $name)';
}
