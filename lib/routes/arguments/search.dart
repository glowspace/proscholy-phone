// used as argument when pushing "/search" route
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/models/tag.dart';

class SearchScreenArguments {
  // indicates that selected song lyric should not be displayed but returned while poping to previous screen
  final bool shouldReturnSongLyric;

  final bool showSearchTitle;

  // filter tag that should be applied initially, used when pushing "/search" from tag displayed in song lyric screen
  final Tag? initialTag;

  final Playlist? playlist;

  final Songbook? songbook;

  SearchScreenArguments({
    this.shouldReturnSongLyric = false,
    this.showSearchTitle = false,
    this.initialTag,
    this.playlist,
    this.songbook,
  });
}
