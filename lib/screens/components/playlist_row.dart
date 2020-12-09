import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/screens/components/highlightable_button.dart';
import 'package:zpevnik/screens/components/highlightable_row.dart';
import 'package:zpevnik/screens/components/reorderable.dart';
import 'package:zpevnik/screens/playlists/playlist_screen.dart';
import 'package:zpevnik/theme.dart';

class PlaylistRow extends StatelessWidget {
  final Playlist playlist;
  final Function(Playlist) select;
  final ValueNotifier<GlobalKey> showingMenuKey;
  final GlobalKey _globalKey;

  PlaylistRow({Key key, this.playlist, this.select, this.showingMenuKey})
      : _globalKey = GlobalKey(),
        super(key: key);

  @override
  Widget build(BuildContext context) => ReorderableItem(
        key: Key('${playlist.id}'),
        childBuilder: _childBuilder,
      );

  Widget _childBuilder(BuildContext context, ReorderableItemState state) {
    final dragging = state == ReorderableItemState.dragProxy || state == ReorderableItemState.dragProxyFinished;

    return Opacity(
      opacity: state == ReorderableItemState.placeholder ? 0 : (state == ReorderableItemState.dragProxy ? 0.75 : 1),
      child: HighlightableRow(
        onPressed: () => _pushPlaylist(context),
        child: Row(children: [
          Container(
            padding: EdgeInsets.only(right: kDefaultPadding),
            child: ReorderableListener(
              child: Icon(Icons.drag_handle, color: AppThemeNew.of(context).iconColor),
            ),
          ),
          Expanded(child: Text(playlist.name, style: AppThemeNew.of(context).bodyTextStyle)),
          // fixme: has big padding on android
          HighlightableButton(
            onPressed: () {
              select(playlist);
              showingMenuKey.value = showingMenuKey.value == null ? _globalKey : null;
            },
            padding: null,
            icon: Icon(Icons.more_vert, key: dragging ? null : _globalKey),
          ),
        ]),
      ),
    );
  }

  void _pushPlaylist(BuildContext context) {
    FocusScope.of(context).unfocus();

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlaylistScreen(playlist: playlist)));
  }
}
