import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/playlist/playlist_button.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';

const double _iconSize = 20;

class PlaylistRow extends StatelessWidget {
  final Playlist playlist;
  final bool isReorderable;

  final VisualDensity visualDensity;

  const PlaylistRow({
    Key? key,
    required this.playlist,
    this.isReorderable = false,
    this.visualDensity = VisualDensity.standard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dragIndicatorKey = GlobalKey();
    final playlistButtonKey = GlobalKey();

    return Highlightable(
      onTap: () => _pushPlaylist(context),
      padding:
          visualDensity == VisualDensity.comfortable ? const EdgeInsets.symmetric(vertical: kDefaultPadding / 2) : null,
      highlightBackground: true,
      highlightableChildKeys: [dragIndicatorKey, playlistButtonKey],
      child: Row(
        children: [
          if (isReorderable)
            ReorderableDragStartListener(
              key: dragIndicatorKey,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
                child: const Icon(Icons.drag_indicator),
              ),
              index: playlist.rank,
            )
          else
            Container(
              child: Icon(playlist.isFavorites ? Icons.star : Icons.playlist_play_rounded, size: _iconSize),
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2, horizontal: kDefaultPadding),
            ),
          Expanded(child: Text(playlist.name)),
          if (!playlist.isFavorites)
            PlaylistButton(
              key: playlistButtonKey,
              playlist: playlist,
              extendPadding: visualDensity == VisualDensity.standard,
            ),
        ],
      ),
    );
  }

  void _pushPlaylist(BuildContext context) {
    FocusScope.of(context).unfocus();

    Navigator.of(context).pushNamed('/playlist', arguments: playlist);
  }
}
