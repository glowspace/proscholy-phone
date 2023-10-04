import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/playlist/playlist_button.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/routing/router.dart';

class PlaylistRow extends ConsumerWidget {
  final Playlist playlist;
  final bool isReorderable;
  final bool showDragIndicator;

  final ValueNotifier<Playlist>? selectedPlaylist;

  const PlaylistRow({
    super.key,
    required this.playlist,
    this.isReorderable = false,
    this.showDragIndicator = true,
    this.selectedPlaylist,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return DragTarget<SongLyric>(
      onAccept: (songLyric) => ref.read(playlistsProvider.notifier).addToPlaylist(playlist, songLyric: songLyric),
      builder: (_, acceptList, __) => Highlightable(
        highlightBackground: true,
        onTap: () => _pushPlaylist(context, ref),
        child: Container(
          color: acceptList.isEmpty ? null : theme.highlightColor,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kDefaultRadius),
              color: selectedPlaylist?.value == playlist ? theme.colorScheme.secondaryContainer : null,
            ),
            child: Row(children: [
              if (isReorderable && showDragIndicator)
                ReorderableDragStartListener(
                  index: playlist.rank,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
                    child: Icon(Icons.drag_indicator),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
                  child: Icon(playlist.isFavorites ? Icons.star : Icons.playlist_play_rounded),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
    if (selectedPlaylist != null) {
      selectedPlaylist!.value = playlist;
    } else {
      context.push('/playlist', arguments: playlist);
    }
  }
}
