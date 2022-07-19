import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/navigation.dart';

const _emptyPlaylistNameMessage = 'Název playlistu je prázdný';

void showPlaylistDialog(BuildContext context, {SongLyric? selectedSongLyric, bool openPlaylist = false}) async {
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
    final dataProvider = context.read<DataProvider>();

    final playlist = dataProvider.createPlaylist(results[0]);

    if (selectedSongLyric != null) dataProvider.addToPlaylist(selectedSongLyric, playlist);

    if (openPlaylist) Navigator.of(context).popAndPushNamed('/playlist', arguments: playlist);
  }
}

void showRenamePlaylistDialog(BuildContext context, Playlist playlist) async {
  final results = await showTextInputDialog(
    context: context,
    title: 'Přejmenovat playlist',
    okLabel: 'Přejmenovat',
    cancelLabel: 'Zrušit',
    textFields: [
      DialogTextField(
        hintText: 'Název',
        initialText: playlist.name,
        validator: (text) => (text?.isEmpty ?? true) ? _emptyPlaylistNameMessage : null,
      ),
    ],
  );

  if (results != null) context.read<DataProvider>().renamePlaylist(playlist, results[0]);
}

void showDuplicatePlaylistDialog(BuildContext context, Playlist playlist) async {
  final results = await showTextInputDialog(
    context: context,
    title: 'Duplikovat playlist',
    okLabel: 'Vytvořit',
    cancelLabel: 'Zrušit',
    textFields: [
      DialogTextField(
        hintText: 'Název',
        initialText: '${playlist.name} (kopie)',
        validator: (text) => (text?.isEmpty ?? true) ? _emptyPlaylistNameMessage : null,
      ),
    ],
  );

  if (results != null) {
    final duplicatedPlaylist = context.read<DataProvider>().duplicatePlaylist(playlist, results[0]);

    if (ModalRoute.of(context)?.settings.name != '/playlists') {
      Navigator.of(context).pushNamed('/playlist', arguments: duplicatedPlaylist);
    }
  }
}

void showremovePlaylistDialog(BuildContext context, Playlist playlist) async {
  final result = await showOkCancelAlertDialog(
    context: context,
    title: 'Smazat playlist',
    okLabel: 'Smazat',
    isDestructiveAction: true,
    cancelLabel: 'Zrušit',
  );

  if (result == OkCancelResult.ok) {
    context.read<DataProvider>().removePlaylist(playlist);

    if (ModalRoute.of(context)?.settings.name == '/playlist') Navigator.of(context).pop();
  }
}
