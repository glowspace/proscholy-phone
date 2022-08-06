import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';

class SongLyricScreenArguments {
  final List<SongLyric> songLyrics;
  final int index;

  final bool isTablet;
  final bool shouldShowBanner;

  final Playlist? playlist;

  SongLyricScreenArguments(
    this.songLyrics,
    this.index, {
    this.isTablet = false,
    this.shouldShowBanner = false,
    this.playlist,
  });

  SongLyricScreenArguments copyWith({
    List<SongLyric>? songLyrics,
    int? index,
    bool? isTablet,
    bool? shouldShowBanner,
    Playlist? playlist,
  }) =>
      SongLyricScreenArguments(
        songLyrics ?? this.songLyrics,
        index ?? this.index,
        isTablet: isTablet ?? this.isTablet,
        shouldShowBanner: shouldShowBanner ?? this.shouldShowBanner,
        playlist: playlist ?? this.playlist,
      );
}
