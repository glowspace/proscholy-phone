import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zpevnik/models/song_lyric.dart';

part 'song_lyric.freezed.dart';

@freezed
class SongLyricScreenArguments with _$SongLyricScreenArguments {
  const factory SongLyricScreenArguments({
    required List<SongLyric> songLyrics,
    @Default(0) int index,
  }) = _SongLyricScreenArguments;
}
