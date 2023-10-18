import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/routing/router.dart';

const _emptyPlaylistNameMessage = 'Název playlistu je prázdný';
const _playlistWithSameNameMessage = 'Playlist s tímto názvem již existuje';

void showPlaylistDialog(BuildContext context, WidgetRef ref, {SongLyric? selectedSongLyric}) async {
  final results = await showTextInputDialog(
    context: context,
    title: 'Nový playlist',
    okLabel: 'Vytvořit',
    cancelLabel: 'Zrušit',
    textFields: [DialogTextField(hintText: 'Název', validator: _validator(ref.read(playlistsProvider)))],
  );

  if (results != null) {
    final playlist = ref.read(playlistsProvider.notifier).createPlaylist(results.first);

    if (context.mounted && selectedSongLyric != null) context.popAndPush('/playlist', arguments: playlist);
  }
}

void showRenamePlaylistDialog(BuildContext context, WidgetRef ref, Playlist playlist) async {
  final results = await showTextInputDialog(
    context: context,
    title: 'Přejmenovat playlist',
    okLabel: 'Přejmenovat',
    cancelLabel: 'Zrušit',
    textFields: [
      DialogTextField(
        hintText: 'Název',
        initialText: playlist.name,
        validator: _validator(ref.read(playlistsProvider), originalPlaylist: playlist),
      )
    ],
  );

  if (results != null) ref.read(playlistsProvider.notifier).renamePlaylist(playlist, results.first);
}

void showDuplicatePlaylistDialog(BuildContext context, WidgetRef ref, Playlist playlist) async {
  final results = await showTextInputDialog(
    context: context,
    title: 'Duplikovat playlist',
    okLabel: 'Vytvořit',
    cancelLabel: 'Zrušit',
    textFields: [
      DialogTextField(
        hintText: 'Název',
        initialText: '${playlist.name} (kopie)',
        validator: _validator(ref.read(playlistsProvider)),
      ),
    ],
  );

  if (results != null) {
    final duplicatedPlaylist = ref.read(playlistsProvider.notifier).duplicatePlaylist(playlist, results.first);

    if (context.mounted) context.push('/playlist', arguments: duplicatedPlaylist);
  }
}

void showAcceptReceivedPlaylistDialog(BuildContext context, Map<String, dynamic> playlistData) async {
  final ref = ProviderScope.containerOf(context);

  final results = await showTextInputDialog(
    context: context,
    title: 'Přidat playlist',
    okLabel: 'Přidat',
    cancelLabel: 'Zrušit',
    textFields: [
      DialogTextField(
        hintText: 'Název',
        initialText: playlistData['name'],
        validator: _validator(ref.read(playlistsProvider)),
      )
    ],
  );

  if (results != null) {
    final acceptedPlaylist = ref.read(playlistsProvider.notifier).acceptPlaylist(playlistData, results.first);

    if (context.mounted) context.push('/playlist', arguments: acceptedPlaylist);
  }
}

void showRemovePlaylistDialog(BuildContext context, WidgetRef ref, Playlist playlist) async {
  final result = await showOkCancelAlertDialog(
    context: context,
    title: 'Smazat playlist',
    okLabel: 'Smazat',
    isDestructiveAction: true,
    cancelLabel: 'Zrušit',
  );

  if (result == OkCancelResult.ok) {
    ref.read(playlistsProvider.notifier).removePlaylist(playlist);

    if (context.mounted && context.isPlaylist) context.pop();
  }
}

String? Function(String?) _validator(List<Playlist> playlists, {Playlist? originalPlaylist}) {
  return (text) => (text?.isEmpty ?? true)
      ? _emptyPlaylistNameMessage
      : (playlists.any((playlist) => playlist.name == text && playlist != originalPlaylist)
          ? _playlistWithSameNameMessage
          : null);
}
