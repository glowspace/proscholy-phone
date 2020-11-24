import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/entities/playlist.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/screens/components/bottom_form_sheet.dart';
import 'package:zpevnik/screens/components/menu_item.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/database.dart';

class PlaylistsProvider extends ChangeNotifier {
  List<Playlist> _playlists;
  String _searchText;

  PlaylistsProvider._()
      : _playlists = DataProvider.shared.playlists
          ..sort((first, second) => second.entity.orderValue.compareTo(first.entity.orderValue)),
        _searchText = '';

  static final PlaylistsProvider shared = PlaylistsProvider._();

  List<Playlist> get allPlaylists => _playlists;

  List<Playlist> get playlists =>
      _playlists.where((playlist) => !playlist.isArchived && playlist.name.contains(_searchText)).toList();

  List<Playlist> get archivedPlaylists =>
      _playlists.where((playlist) => playlist.isArchived && playlist.name.contains(_searchText)).toList();

  void _addPlaylist(String name, List<SongLyric> songLyrics, {bool append = false}) {
    final playlist = PlaylistEntity(id: Playlist.nextId, name: name, orderValue: Playlist.nextOrder++);

    playlist.songLyrics = songLyrics.map((songLyric) {
      songLyric.entity.playlists.add(playlist);
      return songLyric.entity;
    }).toList();

    Database.shared.savePlaylist(playlist);
    if (append)
      _playlists.add(Playlist(playlist));
    else
      _playlists.insert(0, Playlist(playlist));

    notifyListeners();
  }

  void duplicate(Playlist playlist) => _addPlaylist('${playlist.name} (kopie)', playlist.songLyrics, append: true);

  void remove(Playlist playlist) {
    _playlists.remove(playlist);

    Database.shared.removePlaylist(playlist.entity);
  }

  void showPlaylists(BuildContext context, List<SongLyric> songLyrics) {
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      builder: (context) => SizedBox(
        height: 0.67 * MediaQuery.of(context).size.height,
        child: BottomFormSheet(
          title: 'Playlisty',
          items: [
            MenuItem(
              title: 'Nový playlist',
              icon: Icons.add,
              onPressed: () => showPlaylistDialog(context),
            ),
            for (final playlist in playlists)
              MenuItem(
                title: playlist.name,
                onPressed: () {
                  playlist.addSongLyrics(songLyrics);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void showPlaylistDialog(BuildContext context, {Function() callback}) {
    final textFieldController = TextEditingController();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Vytvořit playlist'),
        content: Container(
          child: TextField(
            decoration: InputDecoration(border: InputBorder.none, hintText: 'Název'),
            controller: textFieldController,
          ),
        ),
        actions: [
          TextButton(
            child: Text('Zrušit', style: AppThemeNew.of(context).bodyTextStyle.copyWith(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // fixme: don't know better way to do it now, but there must be
          ChangeNotifierProvider.value(
            value: textFieldController,
            child: Consumer<TextEditingController>(
              builder: (context, controller, _) => TextButton(
                child: Text('Vytvořit'),
                onPressed: controller.text.isEmpty
                    ? null
                    : () {
                        _addPlaylist(controller.text, []);
                        if (callback != null) callback();
                        Navigator.of(context).pop();
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
