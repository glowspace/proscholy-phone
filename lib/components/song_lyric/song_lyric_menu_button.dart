import 'package:flutter/material.dart' hide PopupMenuEntry, PopupMenuItem;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/components/custom/popup_menu_button.dart';
import 'package:zpevnik/components/icon_item.dart';
import 'package:zpevnik/components/playlist/playlists_sheet.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/custom/popup_menu.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/nearby_song_lyrics.dart';

enum SongLyricMenuAction {
  addToPlaylist,
  sync,
  share,
  openInBrowser,
  report,
}

class SongLyricMenuButton extends ConsumerWidget {
  final SongLyric songLyric;

  const SongLyricMenuButton({Key? key, required this.songLyric}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomPopupMenuButton<SongLyricMenuAction>(
      items: _buildPopupMenuItems(context, ref),
      onSelected: (context, action) => _selectedAction(context, ref, action),
      padding: const EdgeInsets.only(left: kDefaultPadding, right: 2 * kDefaultPadding),
    );
  }

  List<PopupMenuEntry<SongLyricMenuAction>> _buildPopupMenuItems(BuildContext context, WidgetRef ref) {
    return [
      const PopupMenuItem(
        value: SongLyricMenuAction.addToPlaylist,
        child: IconItem(icon: Icons.playlist_add, text: 'Přidat do seznamu'),
      ),
      PopupMenuItem(
        value: SongLyricMenuAction.sync,
        child: IconItem(
          icon: Icons.tap_and_play,
          text: ref.watch(songLyricsAdvertiserProvider) ? 'Ukončit sdílení' : 'Sdílet stav s okolím',
        ),
      ),
      const PopupMenuItem(
        value: SongLyricMenuAction.share,
        child: IconItem(icon: Icons.share, text: 'Sdílet'),
      ),
      const PopupMenuItem(
        value: SongLyricMenuAction.openInBrowser,
        child: IconItem(icon: Icons.language, text: 'Otevřít na webu'),
      ),
      const PopupMenuItem(
        value: SongLyricMenuAction.report,
        child: IconItem(icon: Icons.warning, text: 'Nahlásit'),
      ),
    ];
  }

  void _selectedAction(BuildContext context, WidgetRef ref, SongLyricMenuAction? action) {
    if (action == null) return;

    final version = context.read<DataProvider>().packageInfo.version;
    final platform = Theme.of(context).platform == TargetPlatform.iOS ? 'iOS' : 'android';

    switch (action) {
      case SongLyricMenuAction.addToPlaylist:
        _showPlaylists(context);
        break;
      case SongLyricMenuAction.sync:
        ref.read(songLyricsAdvertiserProvider.notifier).toggleAdvertising(songLyric);
        break;
      case SongLyricMenuAction.share:
        final box = context.findRenderObject() as RenderBox?;

        Share.share('$songUrl/${songLyric.id}/', sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
        break;
      case SongLyricMenuAction.openInBrowser:
        launchUrl(Uri.parse('$songUrl/${songLyric.id}/'));
        break;
      case SongLyricMenuAction.report:
        launchUrl(Uri.parse('$reportSongLyricUrl?customfield_10056=${songLyric.id}+$version+$platform'));
        break;
    }
  }

  void _showPlaylists(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
      builder: (context) => PlaylistsSheet(selectedSongLyric: songLyric),
    );
  }
}
