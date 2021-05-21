import 'package:flutter/material.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/utils/database.dart';

class Playlist {
  final PlaylistEntity _entity;

  static int nextOrder = 1;
  // fixme: should be used as auto incorement, but doesn't work
  static int nextId = 1;

  List<SongLyric> _songLyrics;

  Playlist(this._entity) {
    if (_entity.order >= nextOrder) nextOrder = _entity.order + 1;
    if (_entity.id >= nextId) nextId = _entity.id + 1;
  }

  PlaylistEntity get entity => _entity;

  Key get key => Key('$id');

  int get id => _entity.id;

  String get name => _entity.name;

  bool get isArchived => _entity.isArchived;

  // todo: probably can be optmized using db, but it's good enough for now
  List<SongLyric> get songLyrics => _songLyrics ??= DataProvider.shared.songLyrics
      .where((songLyric) => songLyric.entity.playlists.any((playlist) => playlist.id == _entity.id))
      .toList()
        ..sort((first, second) => first.name.compareTo(second.name));

  void addSongLyrics(List<SongLyric> songLyrics) {
    // fixme: temporary fix, _songLyrics might be null at this time, so make sure it's not
    _songLyrics ??= DataProvider.shared.songLyrics
        .where((songLyric) => songLyric.entity.playlists.any((playlist) => playlist.id == _entity.id))
        .toList()
          ..sort((first, second) => first.name.compareTo(second.name));

    final songLyricsSet = _songLyrics.toSet()..addAll(songLyrics);
    _songLyrics = songLyricsSet.toList()..sort((first, second) => first.name.compareTo(second.name));

    Database.shared.addPlaylistSongLyrics(_entity, songLyrics.map((songLyric) => songLyric.entity).toList());
  }

  set name(String value) {
    _entity.name = value;

    Database.shared.updatePlaylist(_entity, ['name'].toSet());
  }

  set order(int value) {
    _entity.order = value;

    Database.shared.updatePlaylist(_entity, ['order_value'].toSet());
  }

  set isArchived(bool value) {
    _entity.isArchived = value;

    Database.shared.updatePlaylist(_entity, ['is_archived'].toSet());
  }
}
