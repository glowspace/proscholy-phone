import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zpevnik/components/open_all_button.dart';
import 'package:zpevnik/components/playlist/playlist_row.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/providers/playlists.dart';

const _maxShowingPlaylists = 3;

class SongListsSection extends ConsumerWidget {
  const SongListsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = [ref.read(favoritePlaylistProvider)] + ref.watch(playlistsProvider);

    return Section(
      title: Text('Moje seznamy', style: Theme.of(context).textTheme.titleLarge),
      action: OpenAllButton(
        title: 'Všechny seznamy',
        onTap: () => context.push('/playlists'),
      ),
      child: ListView.separated(
        itemCount: min(_maxShowingPlaylists, playlists.length),
        itemBuilder: (_, index) => PlaylistRow(playlist: playlists[index], visualDensity: VisualDensity.comfortable),
        separatorBuilder: (_, __) => const Divider(height: 0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
