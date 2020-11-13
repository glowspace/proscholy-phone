import 'package:zpevnik/models/entities/playlist.dart';
import 'package:zpevnik/models/songLyric.dart';

class Playlist {
  final PlaylistEntity _entity;

  List<SongLyric> _songLyrics;

  Playlist(this._entity);

  int get id => _entity.id;

  String get name => _entity.name;

  bool get isArchived => _entity.isArchived;
}
