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

    notifyListeners();
  }
}

class _PlaylistsProvider extends ChangeNotifier {
  final List<Playlist> _playlists;

  _PlaylistsProvider(this._playlists);

  // void addPlaylist(String name, {List<int> songLyrics = const [], int rank = 0}) async {
  //   final playlist = await Playlist.create(name, rank, songLyrics: songLyrics);

  //   _playlists.insert(rank, playlist);

  //   for (int i = rank; i < _playlists.length; i++) _playlists[i].rank = i;

  //   notifyListeners();
  // }

  // // TODO: move context out of this file
  // void addSharedPlaylist(BuildContext context, String playlistName, List<int> songLyrics) {
  //   showDialog<String>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => PlatformDialog(
  //       title: 'Přidat playlist',
  //       initialValue: playlistName,
  //       submitText: 'Přidat',
  //     ),
  //   ).then((text) {
  //     if (text != null) {
  //       addPlaylist(text, songLyrics: songLyrics);
  //     }
  //   });
  // }

  // void duplicate(Playlist playlist) {
  //   final songLyrics = playlist.records.keys.toList();

  //   songLyrics.sort((first, second) => playlist.records[first]!.rank.compareTo(playlist.records[second]!.rank));

  //   addPlaylist('${playlist.name} (kopie)', songLyrics: songLyrics, rank: playlist.rank + 1);
  // }

  // void remove(Playlist playlist) {
  //   _playlists.remove(playlist);

  //   playlist.entity.delete(true);

  //   notifyListeners();
  // }

  // void toggleArchive(Playlist playlist) {
  //   playlist.isArchived = !playlist.isArchived;

  //   notifyListeners();
  // }
}

class PlaylistsProvider extends _PlaylistsProvider with _Reorderable, _Searchable {
  PlaylistsProvider(List<Playlist> allPlaylists) : super(allPlaylists);

  List<Playlist> get playlists => (_searchResults ?? _playlists).where((playlist) => !playlist.isArchived).toList();
  List<Playlist> get archivedPlaylists =>
      (_searchResults ?? _playlists).where((playlist) => playlist.isArchived).toList();
}
