import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/song_lyric.dart';

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
