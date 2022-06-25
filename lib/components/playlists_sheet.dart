import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/icon_item.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';

const _emptyPlaylistNameMessage = 'Název playlistu je prázdný';

class PlaylistsSheet extends StatelessWidget {
  final SongLyric selectedSongLyric;

  const PlaylistsSheet({Key? key, required this.selectedSongLyric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playlists = context.watch<DataProvider>().playlists;

    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.all(kDefaultPadding).copyWith(bottom: kDefaultPadding / 2),
          child: Text('Playlisty', style: Theme.of(context).textTheme.titleLarge),
        ),
        SingleChildScrollView(
          child: Column(children: [
            Highlightable(
              onTap: () => _showPlaylistDialog(context),
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
              child: const IconItem(text: 'Nový playlist', icon: Icons.add, iconSize: 20),
            ),
            const Divider(height: kDefaultPadding),
            ...playlists.map(
              (playlist) => Highlightable(
                onTap: () => _addToPlaylist(context, playlist),
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
                child: IconItem(text: playlist.name, icon: Icons.playlist_play_rounded, iconSize: 20),
              ),
            ),
            const SizedBox(height: kDefaultPadding),
          ]),
        ),
      ],
    );
  }

  void _showPlaylistDialog(BuildContext context) async {
    final results = await showTextInputDialog(
      context: context,
      title: 'Nový playlist',
      okLabel: 'Vytvořit',
      cancelLabel: 'Zrušit',
      textFields: [
        DialogTextField(
          hintText: 'Název',
          validator: (text) => (text?.isEmpty ?? true) ? _emptyPlaylistNameMessage : null,
        ),
      ],
    );

    if (results != null) {
      final playlistName = results[0];

      context.read<DataProvider>().createPlaylist(playlistName);
    }
  }

  void _addToPlaylist(BuildContext context, Playlist playlist) {
    context.read<DataProvider>().addToPlaylist(selectedSongLyric, playlist);

    Navigator.of(context).pop();
  }
}
