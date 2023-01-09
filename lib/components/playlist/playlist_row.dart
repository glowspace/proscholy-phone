import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return DragTarget(
      onAccept: (data) {
        if (data is SongLyric) context.read<DataProvider>().addToPlaylist(data, playlist);
      },
      builder: (_, acceptList, __) => InkWell(
        onTap: () => _pushPlaylist(context),
        child: Container(
          color: acceptList.isEmpty ? null : Theme.of(context).highlightColor,
          padding: visualDensity == VisualDensity.comfortable
              ? const EdgeInsets.symmetric(vertical: kDefaultPadding / 2)
              : null,
          child: Row(
            children: [
              if (isReorderable && showDragIndicator)
                ReorderableDragStartListener(
                  index: playlist.rank,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
                    child: const Icon(Icons.drag_indicator),
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

    NavigationProvider.of(context).pushNamed('/playlist', arguments: playlist);
  }
}
