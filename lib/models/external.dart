import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/song_lyric.dart';

final RegExp _youtubeNameRE = RegExp(r'youtube \(([^|]+\|\s?)?(.+)\)');

@Entity()
class External {
  @Id(assignable: true)
  final int id;

  final String? name;
  final String? mediaId;

  final songLyric = ToOne<SongLyric>();

  External(this.id, this.name, this.mediaId);

  factory External.fromJson(Map<String, dynamic> json, int songLyricId) {
    return External(
      int.parse(json['id'] as String),
      json['name'] as String?,
      json['media_id'] as String?,
    );
  }

  static List<External> fromMapList(Map<String, dynamic> json, int songLyricId) {
    return (json['externals'] as List).map((json) => External.fromJson(json, songLyricId)).toList();
  }

  @override
  String toString() => 'External(id: $id, name: $name)';
}
