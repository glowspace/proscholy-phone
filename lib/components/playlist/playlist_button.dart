import 'package:flutter/material.dart' hide PopupMenuEntry, PopupMenuItem, PopupMenuPosition;
import 'package:zpevnik/components/custom/popup_menu_button.dart';
import 'package:zpevnik/components/icon_item.dart';
import 'package:zpevnik/custom/custom_icon_icons.dart';
import 'package:zpevnik/custom/popup_menu.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/providers/data.dart';

enum PlaylistAction {
  rename,
  share,
  duplicate,
  archive,
  delete,
}

class PlaylistButton extends StatelessWidget {
  final Playlist playlist;
  final bool isInAppBar;

  const PlaylistButton({Key? key, required this.playlist, this.isInAppBar = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenuButton(
      items: _buildPopupMenuItems(context),
      onSelected: _selectedAction,
      menuPosition: isInAppBar ? PopupMenuPosition.under : PopupMenuPosition.over,
      shape: Border.all(color: Theme.of(context).dividerColor),
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
      PopupMenuItem(
        value: PlaylistAction.archive,
        child: IconItem(icon: Icons.archive, text: playlist.isArchived ? 'Zrušit archivaci' : 'Archivovat'),
      ),
      if (playlist.isArchived)
        const PopupMenuItem(
          value: PlaylistAction.delete,
          child: IconItem(icon: Icons.delete, text: 'Odstranit'),
        ),
    ];
  }

  void _selectedAction(BuildContext context, PlaylistAction? action) {
    if (action == null) return;

    switch (action) {
      case PlaylistAction.rename:
        break;
      case PlaylistAction.share:
        break;
      case PlaylistAction.duplicate:
        break;
      case PlaylistAction.archive:
        break;
      case PlaylistAction.delete:
        break;
    }
  }
}
