import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/playlist/playlist_button.dart';
import 'package:zpevnik/components/playlist/selected_playlist.dart';
import 'package:zpevnik/components/selected_row_highlight.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/routing/router.dart';

class PlaylistRow extends ConsumerWidget {
  final Playlist playlist;
  final bool isReorderable;

  const PlaylistRow({super.key, required this.playlist, this.isReorderable = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final leadingIcon = Padding(
      padding: EdgeInsets.fromLTRB(
        context.isHome ? 0.5 * kDefaultPadding : 1.5 * kDefaultPadding,
        kDefaultPadding / 2,
        context.isHome ? 0 : kDefaultPadding,
        kDefaultPadding / 2,
      ),
      child: Icon(
        playlist.isFavorites ? Icons.star : (isReorderable ? Icons.drag_indicator : Icons.playlist_play_rounded),
      ),
    );

    return DragTarget<SongLyric>(
      onAccept: (songLyric) => ref.read(playlistsProvider.notifier).addToPlaylist(playlist, songLyric: songLyric),
      builder: (_, acceptList, __) => Highlightable(
        highlightBackground: true,
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 3),
        onTap: () => _pushPlaylist(context, ref),
        child: Container(
          color: acceptList.isEmpty ? null : theme.highlightColor,
          child: SelectedRowHighlight(
            selectedObjectNotifier: SelectedPlaylist.of(context),
            object: playlist,
            child: Row(children: [
              if (isReorderable)
                ReorderableDragStartListener(index: playlist.rank, child: leadingIcon)
              else
                leadingIcon,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
                  child: Text(playlist.name),
                ),
              ),
              if (!playlist.isFavorites) PlaylistButton(playlist: playlist),
            ]),
          ),
        ),
      ),
    );
  }

  void _pushPlaylist(BuildContext context, WidgetRef ref) {
    final selectedPlaylistNotifier = SelectedPlaylist.of(context);

    if (selectedPlaylistNotifier != null) {
      selectedPlaylistNotifier.value = playlist;
    } else {
      context.push('/playlist', arguments: playlist);
    }
  }
}
