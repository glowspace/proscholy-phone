import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/playlist/playlist_row.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/utils/extensions.dart';

class PlaylistsListView extends StatelessWidget {
  const PlaylistsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        PlaylistRow(playlist: context.providers.read(favoritePlaylistProvider)),
        Consumer(builder: (_, ref, __) {
          final playlists = ref.watch(playlistsProvider);

          return ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 2 * kDefaultPadding),
            itemCount: playlists.length,
            itemBuilder: (_, index) => PlaylistRow(
              key: Key('${playlists[index].id}'),
              playlist: playlists[index],
              isReorderable: true,
            ),
            onReorder: context.providers.read(playlistsProvider.notifier).reorderPlaylists,
          );
        }),
      ]),
    );
  }
}
