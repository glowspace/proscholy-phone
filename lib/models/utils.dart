import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';

List<T> readJsonList<T>(List<dynamic> jsonList, {required T Function(Map<String, dynamic>) mapper}) {
  return [for (final json in jsonList) mapper(json)];
}

ToOne<SongLyric> songLyricFromJson(Map<String, dynamic> json) => toOneFromJson(json);
ToOne<Songbook> songbookFromJson(Map<String, dynamic> json) => toOneFromJson(json);

ToOne<T> toOneFromJson<T>(Map<String, dynamic> json) => ToOne(targetId: int.parse(json['id']!));
