import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/playlist/playlist_row.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/playlists.dart';

class PlaylistsListView extends StatelessWidget {
  const PlaylistsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playlistsProvider = context.watch<PlaylistsProvider>();

    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ReorderableListView.builder(
        key: Key(playlistsProvider.searchText),
        primary: false,
        padding: const EdgeInsets.only(top: kDefaultPadding / 2, bottom: 2 * kDefaultPadding),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        buildDefaultDragHandles: false,
        itemCount: playlistsProvider.playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlistsProvider.playlists[index];

          return PlaylistRow(key: Key('${playlist.id}'), playlist: playlist, isReorderable: true);
        },
        onReorder: (newIndex, oldIndex) => playlistsProvider.onReorder(context, newIndex, oldIndex),
      ),
    );
  }
}
