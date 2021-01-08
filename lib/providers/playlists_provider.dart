import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/entities/playlist.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/screens/components/bottom_form_sheet.dart';
import 'package:zpevnik/screens/components/menu_item.dart';
import 'package:zpevnik/screens/components/platform/platform_dialog.dart';
import 'package:zpevnik/screens/playlists/playlist_sheet.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/database.dart';
import 'package:zpevnik/utils/platform.dart';

class PlaylistsProvider extends ChangeNotifier {
  List<Playlist> _allPlaylists;
  List<Playlist> _playlists;

  String _searchText;

  PlaylistsProvider._()
      : _allPlaylists = DataProvider.shared.playlists
          ..sort((first, second) => second.entity.orderValue.compareTo(first.entity.orderValue)),
        _searchText = '';

  static final PlaylistsProvider shared = PlaylistsProvider._();

  String get searchText => _searchText;

  List<Playlist> get allPlaylists => _playlists ??= _allPlaylists;

  List<Playlist> get playlists =>
      allPlaylists.where((playlist) => !playlist.isArchived && playlist.name.contains(_searchText)).toList();

  List<Playlist> get archivedPlaylists =>
      allPlaylists.where((playlist) => playlist.isArchived && playlist.name.contains(_searchText)).toList();

  void search(String searchText) {
    _searchText = searchText;

    final predicates = _predicates;
    List<List<Playlist>> searchResults = List<List<Playlist>>.generate(predicates.length, (index) => []);

    for (final playlist in _allPlaylists) {
      for (int i = 0; i < predicates.length; i++) {
        if (predicates[i](playlist, _searchText.toLowerCase())) {
          searchResults[i].add(playlist);
          break;
        }
      }
    }

    _playlists = searchResults.reduce((result, list) {
      result.addAll(list);
      return result;
    }).toList();

    notifyListeners();
  }

  List<bool Function(Playlist, String)> get _predicates => [
        (playlist, searchText) => playlist.name.toLowerCase().startsWith(searchText),
        (playlist, searchText) => removeDiacritics(playlist.name.toLowerCase()).startsWith(searchText),
        (playlist, searchText) => playlist.name.toLowerCase().contains(searchText),
        (playlist, searchText) => removeDiacritics(playlist.name.toLowerCase()).contains(searchText),
      ];

  void _addPlaylist(String name, List<SongLyric> songLyrics, {bool append = false}) {
    final playlist = PlaylistEntity(id: Playlist.nextId, name: name, orderValue: Playlist.nextOrder++);

    playlist.songLyrics = songLyrics.map((songLyric) {
      songLyric.entity.playlists.add(playlist);
      return songLyric.entity;
    }).toList();

    Database.shared.savePlaylist(playlist);
    if (append)
      _allPlaylists.add(Playlist(playlist));
    else
      _allPlaylists.insert(0, Playlist(playlist));

    notifyListeners();
  }

  void duplicate(Playlist playlist) => _addPlaylist('${playlist.name} (kopie)', playlist.songLyrics, append: true);

  void remove(Playlist playlist) {
    _allPlaylists.remove(playlist);

    Database.shared.removePlaylist(playlist.entity);
  }

  void showPlaylists(BuildContext context, List<SongLyric> songLyrics) {
    FocusScope.of(context).unfocus();

    showPlatformBottomSheet(
      context: context,
      child: PlaylistSheet(songLyrics: songLyrics),
      height: 0.67 * MediaQuery.of(context).size.height,
    );
  }

  void showPlaylistDialog(BuildContext context, {Function() callback}) => showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => PlatformDialog(
          title: 'Vytvořit playlist',
          onSubmit: (text) {
            _addPlaylist(text, []);
            if (callback != null) callback();
          },
        ),
      );
}
