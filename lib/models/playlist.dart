import 'package:flutter/material.dart';
import 'package:zpevnik/models/model.dart' as model;
import 'package:zpevnik/models/playlist_record.dart';
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

    return entities.map((entity) => Playlist(entity)).toList();
  }

  int get id => entity.id ?? 0;
  String get name => entity.name ?? '';
  int get rank => entity.rank ?? 0;
  bool get isArchived => entity.is_archived ?? false;

  Key get key => Key(id.toString());

  final records = Map<int, PlaylistRecord>.from({});

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

  void addSongLyrics(List<dynamic> songLyricsToAdd) async {
    for (final songLyric in songLyricsToAdd) {
      final int songLyricId;

      if (songLyric is SongLyric)
        songLyricId = songLyric.id;
      else
        songLyricId = songLyric;

      if (!records.containsKey(songLyricId))
        records[songLyricId] = await PlaylistRecord.create(songLyricId, id, records.length);
    }
  }

  void removeSongLyrics(List<SongLyric> songLyrics) {
    for (final songLyric in songLyrics) {
      records[songLyric.id]?.entity.delete(true);
      records.remove(songLyric.id);
    }
  }

  void reorderSongLyrics(List<SongLyric> orderedSongLyrics) {
    int rank = 0;

    for (final songLyric in orderedSongLyrics) records[songLyric.id]?.rank = rank++;
  }
}
