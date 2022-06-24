import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';

@Entity()
class SongbookRecord {
  @Id(assignable: true)
  final int id;

  final String number;

  final songLyric = ToOne<SongLyric>();
  final songbook = ToOne<Songbook>();

  SongbookRecord(this.id, this.number);

  factory SongbookRecord.fromJson(Map<String, dynamic> json, int songLyricId) {
    return SongbookRecord(
      int.parse(json['id'] as String),
      json['number'] as String,
    )
      ..songLyric.targetId = songLyricId
      ..songbook.targetId = int.parse(json['songbook']['id'] as String);
  }

  static List<SongbookRecord> fromMapList(Map<String, dynamic> json, int songLyricId) {
    return (json['songbook_records'] as List).map((json) => SongbookRecord.fromJson(json, songLyricId)).toList();
  }

  @override
  String toString() => 'SongbookRecord(id: $id, number: $number)';
}
