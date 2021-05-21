import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/song_lyric.dart';

class Song {
  final SongEntity _entity;

  Song(this._entity);

  int get id => _entity.id;

  String get name => _entity.name;

  List<SongLyric> songLyrics;
}
