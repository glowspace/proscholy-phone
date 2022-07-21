import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/playlist/playlist_button.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/navigation.dart';

const double _iconSize = 20;

class PlaylistRow extends StatelessWidget {
  final Playlist playlist;
  final bool isReorderable;
  final bool showDragIndicator;

  final VisualDensity visualDensity;

  const PlaylistRow({
    Key? key,
    required this.playlist,
    this.isReorderable = false,
    this.showDragIndicator = true,
    this.visualDensity = VisualDensity.standard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dragIndicatorKey = GlobalKey();
    final playlistButtonKey = GlobalKey();

    return DragTarget(
      onAccept: (data) {
        if (data is SongLyric) context.read<DataProvider>().addToPlaylist(data, playlist);
      },
      builder: (_, acceptList, __) => Highlightable(
        onTap: () => _pushPlaylist(context),
        padding: visualDensity == VisualDensity.comfortable
            ? const EdgeInsets.symmetric(vertical: kDefaultPadding / 2)
            : null,
        color: acceptList.isEmpty ? null : Theme.of(context).highlightColor,
        highlightBackground: true,
        highlightableChildKeys: [dragIndicatorKey, playlistButtonKey],
        child: Row(
          children: [
            if (isReorderable && showDragIndicator)
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
      ),
    );
  }

  void _pushPlaylist(BuildContext context) {
    FocusScope.of(context).unfocus();

    NavigationProvider.of(context).pushNamed('/playlist', arguments: playlist);
  }
}
