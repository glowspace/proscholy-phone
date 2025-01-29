import 'package:flutter/material.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/components/playlist/playlist_button.dart';
import 'package:proscholy_common/components/playlist/selected_playlist.dart';
import 'package:proscholy_common/components/selected_row_highlight.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/utils/extensions.dart';

class PlaylistRow extends StatelessWidget {
  final Playlist playlist;
  final bool isReorderable;

  const PlaylistRow({super.key, required this.playlist, this.isReorderable = false});

  @override
  Widget build(BuildContext context) {
    final leadingIcon = Padding(
      padding: EdgeInsets.fromLTRB(
        context.isHome ? kDefaultPadding / 2 : 1.5 * kDefaultPadding,
        kDefaultPadding / 2,
        context.isHome ? 0 : kDefaultPadding,
        kDefaultPadding / 2,
      ),
      child: Icon(
        playlist.isFavorites ? Icons.star : (isReorderable ? Icons.drag_indicator : Icons.playlist_play_rounded),
      ),
    );

    return HighlightableWidget(
      highlightBackground: true,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 3),
      onTap: () => _pushPlaylist(context),
      child: SelectedRowHighlight(
        selectedObjectNotifier: SelectedPlaylist.of(context),
        object: playlist,
        child: Row(children: [
          if (isReorderable) ReorderableDragStartListener(index: playlist.rank, child: leadingIcon) else leadingIcon,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
              child: Text(playlist.name),
            ),
          ),
          if (!playlist.isFavorites) PlaylistButton(playlist: playlist),
        ]),
      ),
    );
  }

  void _pushPlaylist(BuildContext context) {
    final selectedPlaylistNotifier = SelectedPlaylist.of(context);

    if (selectedPlaylistNotifier != null) {
      selectedPlaylistNotifier.value = playlist;
    } else {
      context.push('/playlist', arguments: playlist);
    }
  }
}
