import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/playlist/playlist_row.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';

const _noPlaylistsText =
    'Nemáte vytvořený žádný seznam písní. Klikněte na${unbreakableSpace}tlačítko níže pro vytvoření nového seznamu.';

class PlaylistsListView extends StatelessWidget {
  const PlaylistsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final playlists = dataProvider.playlists;

    if (playlists.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: const Center(child: Text(_noPlaylistsText, textAlign: TextAlign.center)),
      );
    }

    return SingleChildScrollView(
      child: Column(children: [
        PlaylistRow(playlist: dataProvider.favorites),
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
            onReorder: dataProvider.reorderedPlaylists,
          ),
        ),
      ]),
    );
  }
}
