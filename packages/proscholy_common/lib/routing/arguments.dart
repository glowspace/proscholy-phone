import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:proscholy_common/models/bible_verse.dart';
import 'package:proscholy_common/models/custom_text.dart';
import 'package:proscholy_common/models/model.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/songbook.dart';

@immutable
class DisplayScreenArguments {
  final List<DisplayableItem> items;
  final int initialIndex;

  final bool showSearchScreen;

  final Playlist? playlist;
  final Songbook? songbook;

  const DisplayScreenArguments({
    required this.items,
    this.initialIndex = 0,
    this.showSearchScreen = false,
    this.playlist,
    this.songbook,
  });

  factory DisplayScreenArguments.bibleVerse(BibleVerse bibleVerse) {
    return DisplayScreenArguments(items: [bibleVerse]);
  }

  factory DisplayScreenArguments.customText(CustomText customText) {
    return DisplayScreenArguments(items: [customText]);
  }

  factory DisplayScreenArguments.songLyric(SongLyric songLyric, {bool showSearchScreen = false}) {
    return DisplayScreenArguments(items: [songLyric], showSearchScreen: showSearchScreen);
  }

  bool get canShowMenu => playlist != null || songbook != null || showSearchScreen;

  @override
  int get hashCode => Object.hash(runtimeType, items.length, initialIndex);

  @override
  bool operator ==(Object other) {
    return other is DisplayScreenArguments &&
        initialIndex == other.initialIndex &&
        items.length == other.items.length &&
        items[initialIndex].id == other.items[initialIndex].id;
  }
}

@immutable
class SearchScreenArguments {
  final bool shouldReturnSongLyric;

  const SearchScreenArguments({required this.shouldReturnSongLyric});

  factory SearchScreenArguments.returnSongLyric() => const SearchScreenArguments(shouldReturnSongLyric: true);
}
