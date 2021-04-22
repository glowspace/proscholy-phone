import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/custom/custom_icon_icons.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/providers/playlists_provider.dart';
import 'package:zpevnik/screens/components/highlightable_row.dart';
import 'package:zpevnik/platform/components/dialog.dart';
import 'package:zpevnik/platform/components/popup_menu_button.dart';
import 'package:zpevnik/screens/playlists/playlist_screen.dart';
import 'package:zpevnik/theme.dart';

enum PlaylistAction { rename, duplicate, toggleArchive, remove, share }

class PlaylistRow extends StatefulWidget {
  final Playlist playlist;
  final Function() onSelect;
  final bool reorderable;

  PlaylistRow({
    Key key,
    @required this.playlist,
    @required this.onSelect,
    @required this.reorderable,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlaylistRowState();
}

class _PlaylistRowState extends State<PlaylistRow> {
  @override
  Widget build(BuildContext context) => widget.reorderable
      ? ReorderableItem(key: Key('${widget.playlist.id}'), childBuilder: _childBuilder)
      : _row(context, false);

  Widget _childBuilder(BuildContext context, ReorderableItemState state) {
    final dragging = state == ReorderableItemState.dragProxy || state == ReorderableItemState.dragProxyFinished;

    return Opacity(
      opacity: state == ReorderableItemState.placeholder ? 0 : (state == ReorderableItemState.dragProxy ? 0.75 : 1),
      child: _row(context, dragging),
    );
  }

  Widget _row(BuildContext context, bool dragging) {
    final textStyle = AppTheme.of(context).bodyTextStyle;
    final iconColor = AppTheme.of(context).iconColor;

    return HighlightableRow(
      onPressed: () => _pushPlaylist(context),
      child: Row(children: [
        Expanded(child: Text(widget.playlist.name, style: AppTheme.of(context).bodyTextStyle)),
      ]),
      prefix: widget.reorderable ? ReorderableListener(child: Icon(Icons.drag_handle, color: iconColor)) : null,
      suffix: PlatformPopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem<PlaylistAction>(
            value: PlaylistAction.rename,
            child: Row(children: [
              Container(
                padding: EdgeInsets.only(right: kDefaultPadding),
                child: Icon(Icons.drive_file_rename_outline, color: iconColor),
              ),
              Text('Přejmenovat', style: textStyle),
            ]),
          ),
          if (!widget.playlist.isArchived)
            PopupMenuItem<PlaylistAction>(
              value: PlaylistAction.duplicate,
              child: Row(children: [
                Container(
                  padding: EdgeInsets.only(right: kDefaultPadding),
                  child: Icon(CustomIcon.content_duplicate, color: iconColor),
                ),
                Text('Duplikovat', style: textStyle),
              ]),
            ),
          PopupMenuItem<PlaylistAction>(
            value: PlaylistAction.toggleArchive,
            child: Row(children: [
              Container(
                padding: EdgeInsets.only(right: kDefaultPadding),
                child: Icon(Icons.archive, color: iconColor),
              ),
              Text(widget.playlist.isArchived ? 'Zrušit archivaci' : 'Archivovat', style: textStyle),
            ]),
          ),
          if (widget.playlist.isArchived)
            PopupMenuItem<PlaylistAction>(
              value: PlaylistAction.remove,
              child: Row(children: [
                Container(
                  padding: EdgeInsets.only(right: kDefaultPadding),
                  child: Icon(Icons.delete, color: iconColor),
                ),
                Text('Odstranit', style: textStyle),
              ]),
            )
          else
            PopupMenuItem<PlaylistAction>(
              value: PlaylistAction.share,
              child: Row(children: [
                Container(
                  padding: EdgeInsets.only(right: kDefaultPadding),
                  child: Icon(Icons.share, color: iconColor),
                ),
                Text('Sdílet', style: textStyle),
              ]),
            ),
        ],
        onSelected: (action) {
          switch (action) {
            case PlaylistAction.rename:
              _showRenameDialog(context);
              break;
            case PlaylistAction.duplicate:
              PlaylistsProvider.shared.duplicate(widget.playlist);
              break;
            case PlaylistAction.toggleArchive:
              widget.playlist.isArchived = !widget.playlist.isArchived;
              break;
            case PlaylistAction.remove:
              PlaylistsProvider.shared.remove(widget.playlist);
              break;
            case PlaylistAction.share:
              _sharePlaylist();
              break;
          }

          widget.onSelect();
        },
      ),
    );
  }

  void _pushPlaylist(BuildContext context) {
    FocusScope.of(context).unfocus();

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlaylistScreen(playlist: widget.playlist)));
  }

  void _sharePlaylist() {
    final ids = jsonEncode(widget.playlist.songLyrics.map((songLyric) => songLyric.id).toList());
    final uri = Uri.encodeFull('$deepLinkUrl/add_playlist?name=${widget.playlist.name}&ids=${ids.toString()}');

    FlutterShare.share(
      title: widget.playlist.name,
      linkUrl: uri,
      chooserTitle: widget.playlist.name,
    );
  }

  void _showRenameDialog(BuildContext context) => showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => PlatformDialog(
          title: 'Přejmenovat playlist',
          initialValue: widget.playlist.name,
          onSubmit: (text) => setState(() => widget.playlist.name = text),
        ),
      );
}
