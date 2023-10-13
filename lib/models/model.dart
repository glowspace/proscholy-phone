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
  playlist,
  songLyric;

  int get rawValue => switch (this) { RecentItemType.playlist => 0, RecentItemType.songLyric => 1 };

  factory RecentItemType.fromRawValue(int value) {
    return switch (value) {
      0 => RecentItemType.playlist,
      1 => RecentItemType.songLyric,
      _ => throw UnsupportedError('invalid raw value for `RecentItemType`'),
    };
  }
}

abstract class RecentItem extends Identifiable {
  String get name;

  RecentItemType get recentItemType;
}
