import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/models/playlist.dart';

mixin _Searchable on _PlaylistsProvider {
  String _searchText = '';
  List<Playlist>? _searchResults;

  String get searchText => _searchText;

  set searchText(String newValue) {
    _searchText = newValue;

    if (searchText.isEmpty) {
      _searchResults = null;

      notifyListeners();

      return;
    }

    final playlists = Set<Playlist>.identity();

    for (final predicate in _predicates) {
      for (final playlist in _playlists) {
        if (predicate(playlist, searchText.toLowerCase())) playlists.add(playlist);
      }
    }

    _searchResults = playlists.toList();

    notifyListeners();
  }

  List<bool Function(Playlist, String)> get _predicates => [
        (playlist, searchText) => playlist.name.toLowerCase().startsWith(searchText),
        (playlist, searchText) => removeDiacritics(playlist.name.toLowerCase()).startsWith(searchText),
        (playlist, searchText) => playlist.name.toLowerCase().contains(searchText),
        (playlist, searchText) => removeDiacritics(playlist.name.toLowerCase()).contains(searchText),
      ];
}

mixin _Reorderable on _PlaylistsProvider {
  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final playlist = _playlists.removeAt(oldIndex);
    _playlists.insert(newIndex, playlist);

    for (int i = 0; i < _playlists.length; i++) {
      _playlists[i].rank = i;
    }

    notifyListeners();
  }
}

class _PlaylistsProvider extends ChangeNotifier {
  late List<Playlist> _playlists;

  void update(List<Playlist> playlists) {
    _playlists = playlists;

    notifyListeners();
  }
}

class PlaylistsProvider extends _PlaylistsProvider with _Reorderable, _Searchable {
  List<Playlist> get playlists => (_searchResults ?? _playlists).where((playlist) => !playlist.isArchived).toList();
  List<Playlist> get archivedPlaylists =>
      (_searchResults ?? _playlists).where((playlist) => playlist.isArchived).toList();
}
