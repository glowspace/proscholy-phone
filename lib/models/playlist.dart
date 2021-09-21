import 'package:flutter/material.dart';
import 'package:zpevnik/models/model.dart' as model;
import 'package:zpevnik/models/song_lyric.dart';

// wrapper around Playlist db model for easier field access
class Playlist {
  final model.Playlist entity;

  Playlist(this.entity);

  static Future<Playlist> create(String name, int rank, {List<int> songLyrics = const []}) async {
    final entity = model.Playlist(name: name, rank: rank, is_archived: false);

    entity.id = await entity.save();

    return Playlist(entity)..addSongLyrics(songLyrics);
  }

  static Future<List<Playlist>> get playlists async {
    final entities = await model.Playlist().select().orderBy('rank').toList();

    final playlists = List<Playlist>.empty(growable: true);

    for (final entity in entities) {
      final playlist = Playlist(entity);

      await playlist._preloadSongLyrics();

      playlists.add(playlist);
    }

    return playlists;
  }

  Future<void> _preloadSongLyrics() async {
    _songLyrics =
        (await entity.getSongLyrics(columnsToSelect: ['id'])?.toList())?.map((songLyric) => songLyric.id!).toList();
  }

  int get id => entity.id ?? 0;
  String get name => entity.name ?? '';
  int get rank => entity.rank ?? 0;
  bool get isArchived => entity.is_archived ?? false;

  Key get key => Key(id.toString());

  List<int>? _songLyrics;
  List<int> get songLyrics => _songLyrics ?? [];

  set name(String? value) {
    if (value != null) {
      entity.name = value;
      entity.save();
    }
  }

  set rank(int value) {
    entity.rank = value;
    entity.save();
  }

  set isArchived(bool value) {
    entity.is_archived = value;
    entity.save();
  }

  void addSongLyrics(List<dynamic> songLyrics) {
    if (_songLyrics == null) _songLyrics = [];

    final songLyricPlaylists = List<model.Song_lyricsPlaylists>.empty(growable: true);

    for (final songLyric in songLyrics) {
      final int songLyricId;

      if (songLyric is SongLyric)
        songLyricId = songLyric.id;
      else
        songLyricId = songLyric;

      _songLyrics?.add(songLyricId);

      songLyricPlaylists.add(model.Song_lyricsPlaylists(song_lyricsId: songLyricId, playlistsId: id));
    }

    model.Song_lyricsPlaylists().upsertAll(songLyricPlaylists);
  }
}
