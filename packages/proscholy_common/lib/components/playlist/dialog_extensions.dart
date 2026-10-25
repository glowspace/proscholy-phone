import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proscholy_common/components/playlist/selected_playlist.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/playlists.dart';
import 'package:proscholy_common/utils/extensions.dart';
import 'package:share_plus/share_plus.dart';

const _emptyPlaylistNameMessage = 'Název playlistu je prázdný';
const _playlistWithSameNameMessage = 'Playlist s tímto názvem již existuje';

extension PlaylistDialogsExtension on Playlist {
  static Future<void> createPlaylistWithDialog(BuildContext context, {SongLyric? songLyric}) async {
    final playlists = context.providers.read(playlistsProvider);

    final results = await showTextInputDialog(
      context: context,
      title: 'Nový playlist',
      okLabel: 'Vytvořit',
      cancelLabel: 'Zrušit',
      textFields: [DialogTextField(hintText: 'Název', validator: _playlistNameValidator(playlists))],
    );

    if (results != null && context.mounted) {
      final playlist = context.providers.read(playlistsProvider.notifier).addPlaylist(Playlist.empty(results.first));

      if (songLyric != null) {
        context.providers.read(playlistProvider(playlist.id).notifier).addSongLyric(songLyric);
        context.popAndPush('/playlist', arguments: playlist);
      }
    }
  }

  static Future<void> acceptPlaylistWithDialog(BuildContext context, Map<String, dynamic> playlistData) async {
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
        ),
      ],
    );

    if (results != null && context.mounted) {
      final acceptedPlaylist = context.providers
          .read(playlistsProvider.notifier)
          .acceptPlaylist(playlistData, results.first);

      context.push('/playlist', arguments: acceptedPlaylist);
    }
  }

  Future<void> renameWithDialog(BuildContext context) async {
    final playlists = context.providers.read(playlistsProvider);

    final results = await showTextInputDialog(
      context: context,
      title: 'Přejmenovat playlist',
      okLabel: 'Přejmenovat',
      cancelLabel: 'Zrušit',
      textFields: [
        DialogTextField(
          hintText: 'Název',
          initialText: name,
          validator: _playlistNameValidator(playlists, originalPlaylist: this),
        ),
      ],
    );

    if (results != null && context.mounted) {
      final renamedPlaylist = context.providers.read(playlistProvider(id).notifier).rename(results.first);

      final selectedPlaylistNotifier = SelectedPlaylist.of(context);

      if (selectedPlaylistNotifier != null && selectedPlaylistNotifier.value == this) {
        selectedPlaylistNotifier.value = renamedPlaylist;
      }
    }
  }

  Future<void> duplicateWithDialog(BuildContext context) async {
    final playlists = context.providers.read(playlistsProvider);

    final results = await showTextInputDialog(
      context: context,
      title: 'Duplikovat playlist',
      okLabel: 'Vytvořit',
      cancelLabel: 'Zrušit',
      textFields: [
        DialogTextField(
          hintText: 'Název',
          initialText: '$name (kopie)',
          validator: _playlistNameValidator(playlists),
        ),
      ],
    );

    if (results != null && context.mounted) {
      final duplicatedPlaylist = context.providers.read(playlistProvider(id).notifier).duplicate(results.first);

      final selectedPlaylistNotifier = SelectedPlaylist.of(context);

      if (selectedPlaylistNotifier != null) {
        selectedPlaylistNotifier.value = duplicatedPlaylist;
      } else {
        context.push('/playlist', arguments: duplicatedPlaylist);
      }
    }
  }

  Future<void> removeWithDialog(BuildContext context) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: 'Smazat playlist',
      okLabel: 'Smazat',
      isDestructiveAction: true,
      cancelLabel: 'Zrušit',
    );

    if (result == OkCancelResult.ok && context.mounted) {
      context.providers.read(playlistProvider(id).notifier).remove();

      final selectedPlaylistNotifier = SelectedPlaylist.of(context);

      if (selectedPlaylistNotifier != null) {
        if (selectedPlaylistNotifier.value == this) {
          selectedPlaylistNotifier.value = context.providers.read(favoritePlaylistProvider);
        }
      } else if (context.isPlaylist) {
        context.pop();
      }
    }
  }

  Future<void> share(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox;

    final playlistData = jsonEncode(context.providers.read(playlistsProvider.notifier).playlistToMap(this));
    final fileName = '${(await getApplicationDocumentsDirectory()).path}/${name.replaceAll("/", "-")}.proscholy';
    final file = File(fileName);

    await file.writeAsString(playlistData);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(fileName, mimeType: 'application/json')],
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }
}

String? Function(String?) _playlistNameValidator(List<Playlist> playlists, {Playlist? originalPlaylist}) {
  return (text) => (text?.isEmpty ?? true)
      ? _emptyPlaylistNameMessage
      : (playlists.any((playlist) => playlist.name == text && playlist != originalPlaylist)
            ? _playlistWithSameNameMessage
            : null);
}
