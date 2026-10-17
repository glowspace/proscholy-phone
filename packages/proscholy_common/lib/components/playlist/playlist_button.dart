import 'package:flutter/material.dart' hide PopupMenuEntry, PopupMenuItem;
import 'package:proscholy_common/components/custom/popup_menu_button.dart';
import 'package:proscholy_common/components/icon_item.dart';
import 'package:proscholy_common/components/playlist/dialog_extensions.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/custom/custom_icon_icons.dart';
import 'package:proscholy_common/custom/popup_menu.dart';
import 'package:proscholy_common/models/playlist.dart';

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
        playlist.renameWithDialog(context);
        break;
      case PlaylistAction.share:
        playlist.share(context);
        break;
      case PlaylistAction.duplicate:
        playlist.duplicateWithDialog(context);
        break;
      case PlaylistAction.remove:
        playlist.removeWithDialog(context);
        break;
    }
  }
}
