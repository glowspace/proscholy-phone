import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/playlist/playlist_button.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/routing/router.dart';

const double _iconSize = 20;

class PlaylistRow extends ConsumerWidget {
  final Playlist playlist;
  final bool isReorderable;
  final bool showDragIndicator;

  final VisualDensity visualDensity;

  const PlaylistRow({
    super.key,
    required this.playlist,
    this.isReorderable = false,
    this.showDragIndicator = true,
    this.visualDensity = VisualDensity.standard,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DragTarget<SongLyric>(
      onAccept: (songLyric) => ref.read(playlistsProvider.notifier).addToPlaylist(playlist, songLyric: songLyric),
      builder: (_, acceptList, __) => Highlightable(
        highlightBackground: true,
        onTap: () => _pushPlaylist(context),
        padding: visualDensity == VisualDensity.comfortable
            ? const EdgeInsets.symmetric(vertical: kDefaultPadding / 2)
            : null,
        child: Container(
          color: acceptList.isEmpty ? null : Theme.of(context).highlightColor,
          child: Row(
            children: [
              if (isReorderable && showDragIndicator)
                ReorderableDragStartListener(
                  index: playlist.rank,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
                    child: Icon(Icons.drag_indicator),
                  ),
                )
              else
                Padding(
                  padding: visualDensity == VisualDensity.comfortable
                      ? const EdgeInsets.symmetric(vertical: kDefaultPadding / 2, horizontal: kDefaultPadding)
                      : const EdgeInsets.symmetric(vertical: kDefaultPadding / 2, horizontal: 2 * kDefaultPadding),
                  child: Icon(playlist.isFavorites ? Icons.star : Icons.playlist_play_rounded,
                      size: visualDensity == VisualDensity.comfortable ? _iconSize : null),
                ),
              Expanded(child: Text(playlist.name)),
              if (!playlist.isFavorites)
                PlaylistButton(
                  playlist: playlist,
                  extendPadding: visualDensity == VisualDensity.standard,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _pushPlaylist(BuildContext context) {
    FocusScope.of(context).unfocus();

    context.push('/playlist', arguments: playlist);
  }
}
