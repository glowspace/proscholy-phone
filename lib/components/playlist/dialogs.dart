import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/navigation.dart';

const _emptyPlaylistNameMessage = 'Název playlistu je prázdný';
const _playlistWithSameNameMessage = 'Playlist s tímto názvem již existuje';

void showPlaylistDialog(BuildContext context, {SongLyric? selectedSongLyric, bool openPlaylist = false}) async {
  // final dataProvider = context.read<DataProvider>();
  // final playlists = dataProvider.playlists;

  // final results = await showTextInputDialog(
  //   context: context,
  //   title: 'Nový playlist',
  //   okLabel: 'Vytvořit',
  //   cancelLabel: 'Zrušit',
  //   textFields: [DialogTextField(hintText: 'Název', validator: _validator(playlists))],
  // );

  // if (results != null) {
  //   final playlist = dataProvider.createPlaylist(results[0]);

  //   if (selectedSongLyric != null) dataProvider.addToPlaylist(selectedSongLyric, playlist);

  //   if (openPlaylist) Navigator.of(context).popAndPushNamed('/playlist', arguments: playlist);
  // }
}

void showRenamePlaylistDialog(BuildContext context, Playlist playlist) async {
  // final dataProvider = context.read<DataProvider>();
  // final playlists = dataProvider.playlists;

  // final results = await showTextInputDialog(
  //   context: context,
  //   title: 'Přejmenovat playlist',
  //   okLabel: 'Přejmenovat',
  //   cancelLabel: 'Zrušit',
  //   textFields: [DialogTextField(hintText: 'Název', initialText: playlist.name, validator: _validator(playlists))],
  // );

  // if (results != null) dataProvider.renamePlaylist(playlist, results[0]);
}

void showDuplicatePlaylistDialog(BuildContext context, Playlist playlist) async {
  // final dataProvider = context.read<DataProvider>();
  // final playlists = dataProvider.playlists;

  // final results = await showTextInputDialog(
  //   context: context,
  //   title: 'Duplikovat playlist',
  //   okLabel: 'Vytvořit',
  //   cancelLabel: 'Zrušit',
  //   textFields: [
  //     DialogTextField(hintText: 'Název', initialText: '${playlist.name} (kopie)', validator: _validator(playlists)),
  //   ],
  // );

  // if (results != null) {
  //   final duplicatedPlaylist = dataProvider.duplicatePlaylist(playlist, results[0]);

  //   if (ModalRoute.of(context)?.settings.name != '/playlists') {
  //     NavigationProvider.of(context).pushNamed('/playlist', arguments: duplicatedPlaylist);
  //   }
  // }
}

void showAcceptSharedPlaylistDialog(
    BuildContext context, String name, List<int> songLyricsIds, List<int>? transpositions) async {
  // final dataProvider = context.read<DataProvider>();
  // final playlists = dataProvider.playlists;

  // final results = await showTextInputDialog(
  //   context: context,
  //   title: 'Přidat playlist',
  //   okLabel: 'Přidat',
  //   cancelLabel: 'Zrušit',
  //   textFields: [DialogTextField(hintText: 'Název', initialText: name, validator: _validator(playlists))],
  // );

  // if (results != null) {
  //   final playlist = dataProvider.createPlaylist(results[0]);
  //   int index = 0;

  //   for (final songLyricId in songLyricsIds) {
  //     final songLyric = dataProvider.getSongLyricById(songLyricId);

  //     if (songLyric != null) {
  //       // TODO: save this with new settings
  //       // if (transpositions != null) songLyric.transposition = transpositions[index++];
  //       dataProvider.addToPlaylist(songLyric, playlist);
  //     }
  //   }

  //   if (ModalRoute.of(context)?.settings.name != '/playlists') {
  //     NavigationProvider.of(context).pushNamed('/playlist', arguments: playlist);
  //   }
  // }
}

void showRemovePlaylistDialog(BuildContext context, Playlist playlist) async {
  // final dataProvider = context.read<DataProvider>();

  // final result = await showOkCancelAlertDialog(
  //   context: context,
  //   title: 'Smazat playlist',
  //   okLabel: 'Smazat',
  //   isDestructiveAction: true,
  //   cancelLabel: 'Zrušit',
  // );

  // if (result == OkCancelResult.ok) {
  //   dataProvider.removePlaylist(playlist);

  //   if (ModalRoute.of(context)?.settings.name == '/playlist') Navigator.of(context).pop();
  // }
}

String? Function(String?) _validator(List<Playlist> playlists) {
  return (text) => (text?.isEmpty ?? true)
      ? _emptyPlaylistNameMessage
      : (playlists.any((playlist) => playlist.name == text) ? _playlistWithSameNameMessage : null);
}
