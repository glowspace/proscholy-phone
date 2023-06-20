import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/playlist/playlist_row.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/playlists.dart';

class PlaylistsListView extends ConsumerWidget {
  const PlaylistsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = ref.watch(playlistsProvider);

    return SingleChildScrollView(
      child: Column(children: [
        PlaylistRow(playlist: ref.read(favoritePlaylistProvider)),
        Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: kDefaultPadding / 2, bottom: 2 * kDefaultPadding),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            buildDefaultDragHandles: false,
            itemCount: playlists.length,
            itemBuilder: (_, index) {
              final playlist = playlists[index];

              return PlaylistRow(key: Key('${playlist.id}'), playlist: playlist, isReorderable: true);
            },
            onReorder: (_, __) {},
          ),
        ),
      ]),
    );
  }
}
