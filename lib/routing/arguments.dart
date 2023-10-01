import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zpevnik/models/song_lyric.dart';

@immutable
class SongLyricScreenArguments {
  final List<SongLyric> songLyrics;
  final int initialIndex;

  const SongLyricScreenArguments({required this.songLyrics, this.initialIndex = 0});

  factory SongLyricScreenArguments.songLyric(SongLyric songLyric) => SongLyricScreenArguments(songLyrics: [songLyric]);
}
