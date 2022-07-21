import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';

class SongLyricScreenArguments {
  final List<SongLyric> songLyrics;
  final int index;

  final bool isTablet;

  final Playlist? playlist;

  SongLyricScreenArguments(this.songLyrics, this.index, {this.isTablet = false, this.playlist});

  SongLyricScreenArguments copyWith({
    List<SongLyric>? songLyrics,
    int? index,
    bool? isTablet,
    Playlist? playlist,
  }) =>
      SongLyricScreenArguments(
        songLyrics ?? this.songLyrics,
        index ?? this.index,
        isTablet: isTablet ?? this.isTablet,
        playlist: playlist ?? this.playlist,
      );
}
