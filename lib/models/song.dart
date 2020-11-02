import 'package:zpevnik/models/entities/song.dart';
import 'package:zpevnik/models/songLyric.dart';

class Song {
  final SongEntity _entity;

  Song(this._entity);

  int get id => _entity.id;

  String get name => _entity.name;

  List<SongLyric> songLyrics;
}
