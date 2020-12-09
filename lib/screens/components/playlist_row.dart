import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/screens/components/highlightable_button.dart';
import 'package:zpevnik/screens/components/highlightable_row.dart';
import 'package:zpevnik/screens/playlists/playlist_screen.dart';
import 'package:zpevnik/theme.dart';

class PlaylistRow extends StatelessWidget {
  final Playlist playlist;
  final Function(Playlist) select;
  final ValueNotifier<GlobalKey> showingMenuKey;
  final bool reorderable;
  final GlobalKey _globalKey;

  PlaylistRow({
    Key key,
    @required this.playlist,
    @required this.select,
    @required this.showingMenuKey,
    @required this.reorderable,
  })  : _globalKey = GlobalKey(),
        super(key: key);

  @override
  Widget build(BuildContext context) =>
      reorderable ? ReorderableItem(key: Key('${playlist.id}'), childBuilder: _childBuilder) : _row(context, false);

  Widget _childBuilder(BuildContext context, ReorderableItemState state) {
    final dragging = state == ReorderableItemState.dragProxy || state == ReorderableItemState.dragProxyFinished;

    return Opacity(
      opacity: state == ReorderableItemState.placeholder ? 0 : (state == ReorderableItemState.dragProxy ? 0.75 : 1),
      child: _row(context, dragging),
    );
  }

  Widget _row(BuildContext context, bool dragging) => HighlightableRow(
        onPressed: () => _pushPlaylist(context),
        child: Row(children: [
          Expanded(child: Text(playlist.name, style: AppTheme.of(context).bodyTextStyle)),
        ]),
        prefix: reorderable
            ? ReorderableListener(child: Icon(Icons.drag_handle, color: AppTheme.of(context).iconColor))
            : null,
        suffix: HighlightableButton(
          onPressed: () {
            select(playlist);
            showingMenuKey.value = showingMenuKey.value == null ? _globalKey : null;
          },
          padding: null,
          icon: Icon(Icons.more_vert, key: dragging ? null : _globalKey),
        ),
      );

  void _pushPlaylist(BuildContext context) {
    FocusScope.of(context).unfocus();

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlaylistScreen(playlist: playlist)));
  }
}
