import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/custom/custom_icon_icons.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/platform/components/dialog.dart';
import 'package:zpevnik/platform/utils/route_builder.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/reorderable_row.dart';
import 'package:zpevnik/components/popup_menu_button.dart' as custom;
import 'package:zpevnik/screens/user/playlist.dart';
import 'package:zpevnik/theme.dart';

enum _PlaylistAction { rename, duplicate, toggleArchive, remove, share }

class PlaylistRow extends StatefulWidget {
  final Playlist playlist;
  final bool isReorderable;

  const PlaylistRow({Key? key, required this.playlist, this.isReorderable = false}) : super(key: key);

  @override
  _PlaylistRowState createState() => _PlaylistRowState();
}

class _PlaylistRowState extends State<PlaylistRow> {
  @override
  Widget build(BuildContext context) {
    final playlist = widget.playlist;

    final child = Row(children: [Expanded(child: Text(playlist.name)), _buildActionsButton(context)]);

    if (widget.isReorderable)
      return ReorderableRow(key: playlist.key, child: child, onTap: () => _pushPlaylist(context));

    return Highlightable(onTap: () => _pushPlaylist(context), child: child);
  }

  Widget _buildActionsButton(BuildContext context) {
    final playlist = widget.playlist;
    final playlistsProvider = context.read<PlaylistsProvider>();

    return custom.PopupMenuButton(
      itemBuilder: (context) => [
        _buildPopupMenuItem(context, _PlaylistAction.rename, 'Přejmenovat', Icons.drive_file_rename_outline),
        if (!playlist.isArchived) _buildPopupMenuItem(context, _PlaylistAction.share, 'Sdílet', Icons.share),
        if (!playlist.isArchived)
          _buildPopupMenuItem(context, _PlaylistAction.duplicate, 'Duplikovat', CustomIcon.content_duplicate),
        _buildPopupMenuItem(context, _PlaylistAction.toggleArchive,
            playlist.isArchived ? 'Zrušit archivaci' : 'Archivovat', Icons.archive),
        _buildPopupMenuItem(context, _PlaylistAction.remove, 'Odstranit', Icons.delete)
      ],
      onSelected: (action) {
        switch (action) {
          case _PlaylistAction.rename:
            _showRenameDialog(context);
            break;
          case _PlaylistAction.duplicate:
            playlistsProvider.duplicate(playlist);
            break;
          case _PlaylistAction.toggleArchive:
            playlistsProvider.toggleArchive(playlist);
            break;
          case _PlaylistAction.remove:
            _removePlaylist(context);
            break;
          case _PlaylistAction.share:
            _sharePlaylist();
            break;
        }
      },
    );
  }

  PopupMenuItem<_PlaylistAction> _buildPopupMenuItem(
    BuildContext context,
    _PlaylistAction action,
    String title,
    IconData icon,
  ) {
    final appTheme = AppTheme.of(context);

    return PopupMenuItem<_PlaylistAction>(
      value: action,
      child: Row(children: [
        Icon(icon, color: appTheme.iconColor),
        SizedBox(width: kDefaultPadding),
        Text(title, style: appTheme.bodyTextStyle),
      ]),
    );
  }

  void _sharePlaylist() {
    final playlist = widget.playlist;
    final songLyrics = playlist.records.keys.toList();

    songLyrics.sort((first, second) => playlist.records[first]!.rank.compareTo(playlist.records[second]!.rank));

    final ids = jsonEncode(songLyrics);
    final uri = Uri.encodeFull('$deepLinkUrl/add_playlist?name=${widget.playlist.name}&ids=${ids.toString()}');

    Share.share(uri);
  }

  void _pushPlaylist(BuildContext context) {
    Navigator.of(context).push(platformRouteBuilder(
      context,
      PlaylistScreen(playlist: widget.playlist),
      types: [ProviderType.data, ProviderType.fullScreen, ProviderType.playlist],
    ));
  }

  void _showRenameDialog(BuildContext context) {
    final playlist = widget.playlist;

    showPlatformDialog<String>(
      context,
      (context) => PlatformDialog(
        title: 'Přejmenovat playlist',
        initialValue: playlist.name,
        submitText: 'Přejmenovat',
      ),
    ).then((text) => setState(() {
          if (text != null) playlist.name = text;
        }));
  }

  void _removePlaylist(BuildContext context) {
    showPlatformDialog<bool>(
      context,
      (context) => ConfirmDialog(
        title: 'Opravdu chcete playlist smazat?',
        confirmText: 'Smazat',
      ),
    ).then((confirmed) {
      if (confirmed != null && confirmed) context.read<PlaylistsProvider>().remove(widget.playlist);
    });
  }
}
