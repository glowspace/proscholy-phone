import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/components/playlist/selected_playlist.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/utils/extensions.dart';

const _emptyPlaylistNameMessage = 'Název playlistu je prázdný';
const _playlistWithSameNameMessage = 'Playlist s tímto názvem již existuje';

void showPlaylistDialog(BuildContext context, {SongLyric? selectedSongLyric}) async {
  final playlists = context.providers.read(playlistsProvider);

  final results = await showTextInputDialog(
    context: context,
    title: 'Nový playlist',
    okLabel: 'Vytvořit',
    cancelLabel: 'Zrušit',
    textFields: [DialogTextField(hintText: 'Název', validator: _playlistNameValidator(playlists))],
  );

  if (results != null && context.mounted) {
    final playlist = context.providers.read(playlistsProvider.notifier).createPlaylist(results.first);

    if (selectedSongLyric != null) {
      context.providers.read(playlistsProvider.notifier).addToPlaylist(playlist, songLyric: selectedSongLyric);
      context.popAndPush('/playlist', arguments: playlist);
    }
  }
}

void showRenamePlaylistDialog(BuildContext context, Playlist playlist) async {
  final playlists = context.providers.read(playlistsProvider);

  final results = await showTextInputDialog(
    context: context,
    title: 'Přejmenovat playlist',
    okLabel: 'Přejmenovat',
    cancelLabel: 'Zrušit',
    textFields: [
      DialogTextField(
        hintText: 'Název',
        initialText: playlist.name,
        validator: _playlistNameValidator(playlists, originalPlaylist: playlist),
      )
    ],
  );

  if (results != null && context.mounted) {
    final renamedPlaylist = context.providers.read(playlistsProvider.notifier).renamePlaylist(playlist, results.first);

    final selectedPlaylistNotifier = SelectedPlaylist.of(context);

    if (selectedPlaylistNotifier != null && selectedPlaylistNotifier.value == playlist) {
      selectedPlaylistNotifier.value = renamedPlaylist;
    }
  }
}

void showDuplicatePlaylistDialog(BuildContext context, Playlist playlist) async {
  final playlists = context.providers.read(playlistsProvider);

  final results = await showTextInputDialog(
    context: context,
    title: 'Duplikovat playlist',
    okLabel: 'Vytvořit',
    cancelLabel: 'Zrušit',
    textFields: [
      DialogTextField(
        hintText: 'Název',
        initialText: '${playlist.name} (kopie)',
        validator: _playlistNameValidator(playlists),
      ),
    ],
  );

  if (results != null && context.mounted) {
    final duplicatedPlaylist =
        context.providers.read(playlistsProvider.notifier).duplicatePlaylist(playlist, results.first);

    final selectedPlaylistNotifier = SelectedPlaylist.of(context);

    if (selectedPlaylistNotifier != null) {
      selectedPlaylistNotifier.value = duplicatedPlaylist;
    } else {
      context.push('/playlist', arguments: duplicatedPlaylist);
    }
  }
}

void showAcceptReceivedPlaylistDialog(BuildContext context, Map<String, dynamic> playlistData) async {
  final playlists = context.providers.read(playlistsProvider);

  final results = await showTextInputDialog(
    context: context,
    title: 'Přidat sdílený playlist',
    okLabel: 'Přidat',
    cancelLabel: 'Zrušit',
    textFields: [
      DialogTextField(
        hintText: 'Název',
        initialText: playlistData['name'],
        validator: _playlistNameValidator(playlists),
      )
    ],
  );

  if (results != null && context.mounted) {
    final acceptedPlaylist =
        context.providers.read(playlistsProvider.notifier).acceptPlaylist(playlistData, results.first);

    context.push('/playlist', arguments: acceptedPlaylist);
  }
}

void showRemovePlaylistDialog(BuildContext context, Playlist playlist) async {
  final result = await showOkCancelAlertDialog(
    context: context,
    title: 'Smazat playlist',
    okLabel: 'Smazat',
    isDestructiveAction: true,
    cancelLabel: 'Zrušit',
  );

  if (result == OkCancelResult.ok && context.mounted) {
    context.providers.read(playlistsProvider.notifier).removePlaylist(playlist);

    final selectedPlaylistNotifier = SelectedPlaylist.of(context);

    if (selectedPlaylistNotifier != null) {
      if (selectedPlaylistNotifier.value == playlist) {
        selectedPlaylistNotifier.value = context.providers.read(favoritePlaylistProvider);
      }
    } else if (context.isPlaylist) {
      context.pop();
    }
  }
}

String? Function(String?) _playlistNameValidator(List<Playlist> playlists, {Playlist? originalPlaylist}) {
  return (text) => (text?.isEmpty ?? true)
      ? _emptyPlaylistNameMessage
      : (playlists.any((playlist) => playlist.name == text && playlist != originalPlaylist)
          ? _playlistWithSameNameMessage
          : null);
}
