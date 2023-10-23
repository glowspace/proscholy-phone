import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/bible_verse.dart';
import 'package:zpevnik/models/custom_text.dart';
import 'package:zpevnik/models/song_lyric.dart';

part 'model.freezed.dart';

abstract class Identifiable {
  int get id;
}

abstract class Record {
  ToOne<SongLyric> get songLyric;
}

abstract class SongsList {
  String get name;

  List<Record> get records;
}

enum RecentItemType {
  bibleVerse,
  customText,
  playlist,
  songbook,
  songLyric;

  int get rawValue => switch (this) {
        RecentItemType.bibleVerse => 0,
        RecentItemType.customText => 1,
        RecentItemType.playlist => 2,
        RecentItemType.songbook => 3,
        RecentItemType.songLyric => 4,
      };

  factory RecentItemType.fromRawValue(int value) {
    return switch (value) {
      0 => RecentItemType.bibleVerse,
      1 => RecentItemType.customText,
      2 => RecentItemType.playlist,
      3 => RecentItemType.songbook,
      4 => RecentItemType.songLyric,
      _ => throw UnsupportedError('invalid raw value for `RecentItemType`'),
    };
  }
}

abstract class RecentItem extends Identifiable {
  String get name;

  RecentItemType get recentItemType;
}

@freezed
class DisplayableItem with _$DisplayableItem implements RecentItem {
  const DisplayableItem._();

  const factory DisplayableItem.bibleVerse(BibleVerse bibleVerse) = BibleVerseItem;
  const factory DisplayableItem.customText(CustomText customText) = CustomTextItem;
  const factory DisplayableItem.songLyric(SongLyric songLyric) = SongLyricItem;

  @override
  int get id => when(
        bibleVerse: (bibleVerse) => bibleVerse.id,
        customText: (customText) => customText.id,
        songLyric: (songLyric) => songLyric.id,
      );

  @override
  String get name => when(
        bibleVerse: (bibleVerse) => bibleVerse.name,
        customText: (customText) => customText.name,
        songLyric: (songLyric) => songLyric.name,
      );

  @override
  RecentItemType get recentItemType => when(
        bibleVerse: (bibleVerse) => bibleVerse.recentItemType,
        songLyric: (songLyric) => songLyric.recentItemType,
        customText: (customText) => customText.recentItemType,
      );
}
