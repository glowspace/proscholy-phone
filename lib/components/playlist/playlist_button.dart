import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide PopupMenuEntry, PopupMenuItem;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zpevnik/components/custom/popup_menu_button.dart';
import 'package:zpevnik/components/icon_item.dart';
import 'package:zpevnik/components/playlist/dialogs.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/custom/custom_icon_icons.dart';
import 'package:zpevnik/custom/popup_menu.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/utils/extensions.dart';

enum PlaylistAction {
  rename,
  share,
  duplicate,
  remove,
}

class PlaylistButton extends StatelessWidget {
  final Playlist playlist;
  final bool isInAppBar;

  const PlaylistButton({
    super.key,
    required this.playlist,
    this.isInAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenuButton(
      items: _buildPopupMenuItems(context),
      onSelected: (context, action) => _selectedAction(context, action),
      menuPosition: isInAppBar ? PopupMenuPosition.under : PopupMenuPosition.over,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
    );
  }

  List<PopupMenuEntry<PlaylistAction>> _buildPopupMenuItems(BuildContext context) {
    return [
      const PopupMenuItem(
        value: PlaylistAction.rename,
        child: IconItem(icon: Icons.drive_file_rename_outline, text: 'Přejmenovat'),
      ),
      const PopupMenuItem(
        value: PlaylistAction.share,
        child: IconItem(icon: Icons.share, text: 'Sdílet'),
      ),
      const PopupMenuItem(
        value: PlaylistAction.duplicate,
        child: IconItem(icon: CustomIcon.contentDuplicate, text: 'Duplikovat'),
      ),
      const PopupMenuItem(
        value: PlaylistAction.remove,
        child: IconItem(icon: Icons.delete, text: 'Odstranit'),
      ),
    ];
  }

  void _selectedAction(BuildContext context, PlaylistAction? action) {
    if (action == null) return;

    switch (action) {
      case PlaylistAction.rename:
        showRenamePlaylistDialog(context, playlist);
        break;
      case PlaylistAction.share:
        _sharePlaylist(context, playlist);
        break;
      case PlaylistAction.duplicate:
        showDuplicatePlaylistDialog(context, playlist);
        break;
      case PlaylistAction.remove:
        showRemovePlaylistDialog(context, playlist);
        break;
    }
  }

  void _sharePlaylist(BuildContext context, Playlist playlist) async {
    final box = context.findRenderObject() as RenderBox;

    final playlistData = jsonEncode(context.providers.read(playlistsProvider.notifier).playlistToMap(playlist));
    final file = File('${(await getApplicationDocumentsDirectory()).path}/${playlist.name}.proscholy');

    file.writeAsString(playlistData);

    await Share.shareXFiles(
      [
        XFile('${(await getApplicationDocumentsDirectory()).path}/${playlist.name}.proscholy',
            mimeType: 'application/data')
      ],
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );

    file.delete();
  }
}
