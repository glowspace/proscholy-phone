import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/platform/components/dialog.dart';
import 'package:zpevnik/providers/utils/searchable.dart';

class PlaylistsProvider extends ChangeNotifier with Searchable<Playlist> {
  final List<Playlist> allPlaylists;

  PlaylistsProvider(this.allPlaylists);

  List<Playlist>? _playlists;

  @override
  List<Playlist> get items => _playlists ?? allPlaylists;

  @override
  set searchText(newValue) {
    super.searchText = newValue;

    _search();
  }

  List<Playlist> get playlists => items.where((playlist) => !playlist.isArchived).toList();
  List<Playlist> get archivedPlaylists => items.where((playlist) => playlist.isArchived).toList();

  bool onReorder(Key key, Key other) {
    int index = allPlaylists.indexWhere((playlist) => playlist.key == key);
    int otherIndex = allPlaylists.indexWhere((playlist) => playlist.key == other);

    final playlist = allPlaylists.removeAt(index);
    allPlaylists.insert(otherIndex, playlist);

    notifyListeners();

    return true;
  }

  void onReorderDone(Key _) {
    for (var i = 0; i < allPlaylists.length; i++) allPlaylists[i].rank = i;
  }

  void addPlaylist(String name, {List<int> songLyrics = const [], int rank = 0}) async {
    final playlist = await Playlist.create(name, rank, songLyrics: songLyrics);

    allPlaylists.insert(rank, playlist);

    for (int i = rank; i < allPlaylists.length; i++) allPlaylists[i].rank = i;

    notifyListeners();
  }

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
    allPlaylists.remove(playlist);

    playlist.entity.delete(true);

    notifyListeners();
  }

  void toggleArchive(Playlist playlist) {
    playlist.isArchived = !playlist.isArchived;

    notifyListeners();
  }

  void _search() {
    if (searchText.isEmpty) {
      _playlists = null;

      notifyListeners();

      return;
    }

    final playlists = Set<Playlist>.identity();

    for (final predicate in _predicates)
      for (final playlist in allPlaylists) if (predicate(playlist, searchText.toLowerCase())) playlists.add(playlist);

    _playlists = playlists.toList();

    notifyListeners();
  }

  List<bool Function(Playlist, String)> get _predicates => [
        (playlist, searchText) => playlist.name.toLowerCase().startsWith(searchText),
        (playlist, searchText) => removeDiacritics(playlist.name.toLowerCase()).startsWith(searchText),
        (playlist, searchText) => playlist.name.toLowerCase().contains(searchText),
        (playlist, searchText) => removeDiacritics(playlist.name.toLowerCase()).contains(searchText),
      ];
}
