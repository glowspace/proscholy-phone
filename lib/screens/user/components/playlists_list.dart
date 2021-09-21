import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart' as reorderable;
import 'package:provider/provider.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/screens/user/components/playlist_row.dart';

class PlaylistsList extends StatelessWidget {
  final List<Playlist> playlists;
  final bool isReorderable;

  const PlaylistsList({Key? key, this.playlists = const [], this.isReorderable = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playlistsProvider = context.read<PlaylistsProvider>();

    final list = ListView.builder(
      itemBuilder: (context, index) => PlaylistRow(playlist: playlists[index], isReorderable: isReorderable),
      itemCount: playlists.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );

    if (isReorderable)
      return reorderable.ReorderableList(
        onReorder: playlistsProvider.onReorder,
        onReorderDone: playlistsProvider.onReorderDone,
        child: list,
      );

    return list;
  }
}
