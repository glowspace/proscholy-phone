import 'package:flutter/material.dart' hide PopupMenuEntry, PopupMenuItem, PopupMenuPosition;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zpevnik/components/custom/popup_menu_button.dart';
import 'package:zpevnik/components/icon_item.dart';
import 'package:zpevnik/components/playlist/dialogs.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/custom/custom_icon_icons.dart';
import 'package:zpevnik/custom/popup_menu.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/providers/data.dart';

enum PlaylistAction {
  rename,
  share,
  duplicate,
  remove,
}

class PlaylistButton extends StatelessWidget {
  final Playlist playlist;
  final bool isInAppBar;
  final bool extendPadding;

  const PlaylistButton({
    Key? key,
    required this.playlist,
    this.isInAppBar = false,
    this.extendPadding = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenuButton(
      items: _buildPopupMenuItems(context),
      onSelected: _selectedAction,
      menuPosition: isInAppBar ? PopupMenuPosition.under : PopupMenuPosition.over,
      padding: extendPadding
          ? const EdgeInsets.fromLTRB(kDefaultPadding, kDefaultPadding / 2, 2 * kDefaultPadding, kDefaultPadding / 2)
          : null,
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
        child: IconItem(icon: CustomIcon.content_duplicate, text: 'Duplikovat'),
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

  void _sharePlaylist(BuildContext context, Playlist playlist) {
    final songLyricsIds = context
        .read<DataProvider>()
        .getPlaylistsSongLyrics(playlist)
        .map((songLyric) => songLyric.id)
        .toList()
        .join(',');

    Share.share(Uri.encodeFull('$deepLinkUrl/add_playlist?name=${playlist.name}&ids=$songLyricsIds'));
  }
}
