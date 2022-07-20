import 'package:zpevnik/models/song_lyric.dart';

class SongLyricScreenArguments {
  final List<SongLyric> songLyrics;
  final int index;

  final bool isTablet;

  SongLyricScreenArguments(this.songLyrics, this.index, {this.isTablet = false});

  SongLyricScreenArguments copyWith({List<SongLyric>? songLyrics, int? index, bool? isTablet}) =>
      SongLyricScreenArguments(
        songLyrics ?? this.songLyrics,
        index ?? this.index,
        isTablet: isTablet ?? this.isTablet,
      );
}
