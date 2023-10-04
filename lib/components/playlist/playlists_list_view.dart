import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/playlist/playlist_row.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/providers/playlists.dart';

class PlaylistsListView extends ConsumerWidget {
  final ValueNotifier<Playlist>? selectedPlaylist;

  const PlaylistsListView({super.key, this.selectedPlaylist});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = ref.watch(playlistsProvider);

    return SingleChildScrollView(
      child: Column(children: [
        PlaylistRow(playlist: ref.read(favoritePlaylistProvider), selectedPlaylist: selectedPlaylist),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 2 * kDefaultPadding),
          itemCount: playlists.length,
          itemBuilder: (_, index) {
            final playlist = playlists[index];

            return PlaylistRow(
              key: Key('${playlist.id}'),
              playlist: playlist,
              isReorderable: true,
              selectedPlaylist: selectedPlaylist,
            );
          },
          onReorder: (_, __) {},
        ),
      ]),
    );
  }
}
