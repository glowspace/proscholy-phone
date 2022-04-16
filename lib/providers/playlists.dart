import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/platform/components/dialog.dart';

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
      for (final playlist in _allPlaylists) {
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
  bool onReorder(Key key, Key other) {
    int index = _allPlaylists.indexWhere((playlist) => playlist.key == key);
    int otherIndex = _allPlaylists.indexWhere((playlist) => playlist.key == other);

    final playlist = _allPlaylists.removeAt(index);
    _allPlaylists.insert(otherIndex, playlist);

    notifyListeners();

    return true;
  }

  void onReorderDone(Key _) {
    for (var i = 0; i < _allPlaylists.length; i++) {
      _allPlaylists[i].rank = i;
    }
  }
}

class _PlaylistsProvider extends ChangeNotifier {
  final List<Playlist> _allPlaylists;

  List<Playlist> get playlists => _allPlaylists;

  _PlaylistsProvider(this._allPlaylists);

  void addPlaylist(String name, {List<int> songLyrics = const [], int rank = 0}) async {
    final playlist = await Playlist.create(name, rank, songLyrics: songLyrics);

    _allPlaylists.insert(rank, playlist);

    for (int i = rank; i < _allPlaylists.length; i++) _allPlaylists[i].rank = i;

    notifyListeners();
  }

  // TODO: move context out of this file
  void addSharedPlaylist(BuildContext context, String playlistName, List<int> songLyrics) {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PlatformDialog(
        title: 'Přidat playlist',
        initialValue: playlistName,
        submitText: 'Přidat',
      ),
    ).then((text) {
      if (text != null) {
        addPlaylist(text, songLyrics: songLyrics);
      }
    });
  }

  void duplicate(Playlist playlist) {
    final songLyrics = playlist.records.keys.toList();

    songLyrics.sort((first, second) => playlist.records[first]!.rank.compareTo(playlist.records[second]!.rank));

    addPlaylist('${playlist.name} (kopie)', songLyrics: songLyrics, rank: playlist.rank + 1);
  }

  void remove(Playlist playlist) {
    _allPlaylists.remove(playlist);

    playlist.entity.delete(true);

    notifyListeners();
  }

  void toggleArchive(Playlist playlist) {
    playlist.isArchived = !playlist.isArchived;

    notifyListeners();
  }
}

class PlaylistsProvider extends _PlaylistsProvider with _Reorderable, _Searchable {
  PlaylistsProvider(List<Playlist> allPlaylists) : super(allPlaylists);

  @override
  List<Playlist> get playlists => (_searchResults ?? _allPlaylists).where((playlist) => !playlist.isArchived).toList();
  List<Playlist> get archivedPlaylists =>
      (_searchResults ?? _allPlaylists).where((playlist) => playlist.isArchived).toList();
}
