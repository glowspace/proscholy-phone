import 'package:flutter/material.dart' hide PopupMenuEntry, PopupMenuItem;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zpevnik/components/custom/popup_menu_button.dart';
import 'package:zpevnik/components/icon_item.dart';
import 'package:zpevnik/components/playlist/playlists_sheet.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/custom/popup_menu.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';

enum SongLyricMenuAction {
  addToPlaylist,
  share,
  openInBrowser,
  report,
}

class SongLyricMenuButton extends StatelessWidget {
  final SongLyric songLyric;

  const SongLyricMenuButton({Key? key, required this.songLyric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenuButton(items: _buildPopupMenuItems(context), onSelected: _selectedAction);
  }

  List<PopupMenuEntry<SongLyricMenuAction>> _buildPopupMenuItems(BuildContext context) {
    return const [
      PopupMenuItem(
        value: SongLyricMenuAction.addToPlaylist,
        child: IconItem(icon: Icons.playlist_add, text: 'Přidat do seznamu'),
      ),
      // PopupMenuItem(
      //   child: _buildItem(context, Icons.tap_and_play, 'Připojit k zařízením v okolí'),
      // ),
      PopupMenuItem(
        value: SongLyricMenuAction.share,
        child: IconItem(icon: Icons.share, text: 'Sdílet'),
      ),
      PopupMenuItem(
        value: SongLyricMenuAction.openInBrowser,
        child: IconItem(icon: Icons.language, text: 'Otevřít na webu'),
      ),
      PopupMenuItem(
        value: SongLyricMenuAction.report,
        child: IconItem(icon: Icons.warning, text: 'Nahlásit'),
      ),
    ];
  }

  void _selectedAction(BuildContext context, SongLyricMenuAction? action) {
    if (action == null) return;

    final version = context.read<DataProvider>().packageInfo.version;
    final platform = Theme.of(context).platform == TargetPlatform.iOS ? 'iOS' : 'android';

    switch (action) {
      case SongLyricMenuAction.addToPlaylist:
        _showPlaylists(context);
        break;
      case SongLyricMenuAction.share:
        Share.share('$songUrl/${songLyric.id}/');
        break;
      case SongLyricMenuAction.openInBrowser:
        launchUrlString('$songUrl/${songLyric.id}/');
        break;
      case SongLyricMenuAction.report:
        launchUrlString('$reportSongLyricUrl?customfield_10056=${songLyric.id}+$version+$platform');
        break;
    }
  }

  void _showPlaylists(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
      builder: (context) => PlaylistsSheet(selectedSongLyric: songLyric),
      useRootNavigator: true,
    );
  }
}
