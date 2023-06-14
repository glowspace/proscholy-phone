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
