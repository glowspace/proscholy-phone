import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart' as reorderable;
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/components/playlist/playlist_row.dart';

const _notFoundText = 'Nenalezeny žádné seznamy písní';
const _noPlaylistText = 'Zatím nemáte vytvořeny žádné seznamy písní';

class PlaylistsList extends StatelessWidget {
  final List<Playlist> playlists;
  final bool isReorderable;

  const PlaylistsList({Key? key, this.playlists = const [], this.isReorderable = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playlistsProvider = context.watch<PlaylistsProvider>();

    final Widget child;

    if (playlists.isNotEmpty) {
      child = ListView.builder(
        itemBuilder: (context, index) => PlaylistRow(playlist: playlists[index], isReorderable: isReorderable),
        itemCount: playlists.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      );
    } else {
      child = Container(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        child: Center(child: Text(playlistsProvider.searchText.isEmpty ? _noPlaylistText : _notFoundText)),
      );
    }

    if (isReorderable) {
      return reorderable.ReorderableList(
        onReorder: playlistsProvider.onReorder,
        onReorderDone: playlistsProvider.onReorderDone,
        child: child,
      );
    }

    return child;
  }
}
