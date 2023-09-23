import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/open_all_button.dart';
import 'package:zpevnik/components/playlist/playlist_row.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/routing/router.dart';

const _maxShowingPlaylists = 3;

class SongListsSection extends ConsumerWidget {
  const SongListsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = [ref.read(favoritePlaylistProvider)] + ref.watch(playlistsProvider);

    return Section(
      outsideTitle: 'Moje seznamy',
      outsideTitleLarge: true,
      margin: const EdgeInsets.symmetric(vertical: 2 / 3 * kDefaultPadding),
      action: OpenAllButton(
        title: 'Zobrazit vše',
        onTap: () => context.push('/playlists'),
      ),
      children: [
        ListView.separated(
          itemCount: min(_maxShowingPlaylists, playlists.length),
          itemBuilder: (_, index) => PlaylistRow(playlist: playlists[index], visualDensity: VisualDensity.comfortable),
          separatorBuilder: (_, __) => const Divider(),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
}
