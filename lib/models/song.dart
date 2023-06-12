import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/song_lyric.dart';

part 'song.freezed.dart';
part 'song.g.dart';

@Freezed(toJson: false)
class Song with _$Song {
  static const String fieldKey = 'songs';

  const Song._();

  @Entity(realClass: Song)
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory Song({
    @Id(assignable: true) @JsonKey(fromJson: int.parse) required int id,
    required String name,
    @Backlink() @JsonKey(fromJson: _songLyricsFromJson) required ToMany<SongLyric> songLyrics,
  }) = _Song;

  factory Song.fromJson(Map<String, Object?> json) => _$SongFromJson(json);

  bool get hasTranslations => songLyrics.length > 1;

  SongLyric? get original => songLyrics.firstWhereOrNull((songLyric) => songLyric.type == SongLyricType.original);
}

ToMany<SongLyric> _songLyricsFromJson(List<dynamic>? jsonList) => ToMany();
