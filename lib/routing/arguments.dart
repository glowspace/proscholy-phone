import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zpevnik/models/bible_verse.dart';
import 'package:zpevnik/models/custom_text.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';

@immutable
class DisplayScreenArguments {
  final List<DisplayableItem> items;
  final int initialIndex;

  final Playlist? playlist;

  const DisplayScreenArguments({required this.items, this.initialIndex = 0, this.playlist});

  factory DisplayScreenArguments.bibleVerse(BibleVerse bibleVerse) {
    return DisplayScreenArguments(items: [bibleVerse]);
  }

  factory DisplayScreenArguments.customText(CustomText customText) {
    return DisplayScreenArguments(items: [customText]);
  }

  factory DisplayScreenArguments.songLyric(SongLyric songLyric) {
    return DisplayScreenArguments(items: [songLyric]);
  }

  @override
  int get hashCode => Object.hash(runtimeType, items, initialIndex);

  @override
  bool operator ==(Object other) {
    return other is DisplayScreenArguments && initialIndex == other.initialIndex && items == other.items;
  }
}

@immutable
class SearchScreenArguments {
  final bool shouldReturnSongLyric;

  const SearchScreenArguments({required this.shouldReturnSongLyric});

  factory SearchScreenArguments.returnSongLyric() => const SearchScreenArguments(shouldReturnSongLyric: true);
}
