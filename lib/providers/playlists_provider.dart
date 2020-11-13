import 'package:flutter/material.dart';
import 'package:zpevnik/models/entities/playlist.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/utils/database.dart';

class PlaylistsProvider extends ChangeNotifier {
  List<Playlist> _playlists;
  String _searchText;

  PlaylistsProvider()
      : _playlists = [],
        _searchText = '';

  List<Playlist> get playlists =>
      playlists.where((playlist) => !playlist.isArchived && playlist.name.contains(_searchText)).toList();

  List<Playlist> get archivedPlaylists =>
      playlists.where((playlist) => playlist.isArchived && playlist.name.contains(_searchText)).toList();

  void addPlaylist(String name, List<SongLyric> songLyrics) {
    final playlist = PlaylistEntity(id: 1, name: name)
      ..songLyrics = songLyrics.map((songLyric) => songLyric.entity).toList();

    Database.shared.savePlaylist(playlist);
    _playlists.add(Playlist(playlist));

    notifyListeners();
  }
}
