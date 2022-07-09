// used as argument when pushing "/search" route
class SearchScreenArguments {
  // indicates that selected song lyric should not be displayed but returned while poping to previous screen
  final bool shouldReturnSongLyric;

  final bool showSearchTitle;

  SearchScreenArguments({this.shouldReturnSongLyric = false, this.showSearchTitle = false});
}
