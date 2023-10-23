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

  factory DisplayScreenArguments.songLyrics(List<SongLyric> songLyrics, {required int initialIndex}) {
    return DisplayScreenArguments(
      items: songLyrics.map((songLyric) => DisplayableItem.songLyric(songLyric)).toList(),
      initialIndex: initialIndex,
    );
  }

  factory DisplayScreenArguments.bibleVerse(BibleVerse bibleVerse) {
    return DisplayScreenArguments(items: [DisplayableItem.bibleVerse(bibleVerse)]);
  }

  factory DisplayScreenArguments.customText(CustomText customText) {
    return DisplayScreenArguments(items: [DisplayableItem.customText(customText)]);
  }

  factory DisplayScreenArguments.songLyric(SongLyric songLyric) {
    return DisplayScreenArguments(items: [DisplayableItem.songLyric(songLyric)]);
  }
}

@immutable
class SearchScreenArguments {
  final bool shouldReturnSongLyric;

  const SearchScreenArguments({required this.shouldReturnSongLyric});

  factory SearchScreenArguments.returnSongLyric() => const SearchScreenArguments(shouldReturnSongLyric: true);
}
