import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/platform/utils/bottom_sheet.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/screens/components/collapseable.dart';
import 'package:zpevnik/screens/components/icon_item.dart';
import 'package:zpevnik/screens/components/playlists_sheet.dart';
import 'package:zpevnik/screens/components/popup_menu.dart';
import 'package:zpevnik/screens/song_lyric/utils/lyrics_controller.dart';
import 'package:zpevnik/theme.dart';

class SongLyricMenu extends StatelessWidget {
  final LyricsController lyricsController;
  final ValueNotifier<bool> collapsed;

  const SongLyricMenu({Key? key, required this.lyricsController, required this.collapsed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CollapseableWidget(child: _buildMenu(context), collapsed: collapsed);
  }

  Widget _buildMenu(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final songLyric = lyricsController.songLyric;

    final projectionText = lyricsController.isProjectionEnabled ? 'Vypnout' : 'Zapnout';

    return PopupMenu(
      border: Border(
        left: BorderSide(color: appTheme.borderColor),
        bottom: BorderSide(color: appTheme.borderColor),
      ),
      children: [
        IconItem(
          title: 'Přidat do seznamu',
          icon: Icons.playlist_add,
          onPressed: () => _doAndHide(context, () => _showPlaylists(context)),
        ),
        // IconItem(
        //   title: 'Připojit k zařízením v okolí',
        //   icon: Icons.tap_and_play,
        //   onPressed: () {
        //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConnectionsScreen()));
        //     collapsed.value = true;
        //   },
        // ),
        IconItem(
          title: '$projectionText prezentační mód',
          icon: Icons.pages,
          onPressed: () => _doAndHide(context, lyricsController.toggleisProjectionEnabled),
        ),
        IconItem(
          title: 'Sdílet',
          icon: Icons.share,
          onPressed: () => _doAndHide(context, () => Share.share('$songUrl/${songLyric.id}/')),
        ),
        IconItem(
          title: 'Otevřít na webu',
          icon: Icons.language,
          onPressed: () => _doAndHide(context, () => launch('$songUrl/${songLyric.id}/')),
        ),
        IconItem(
          title: 'Nahlásit',
          icon: Icons.warning,
          onPressed: () => _doAndHide(
              context, () async => launch('$reportUrl?customfield_10056=${await _generateCustomField(context)}')),
        ),
      ],
    );
  }

  void _doAndHide(BuildContext context, Function() func) {
    func();

    collapsed.value = true;
  }

  void _showPlaylists(BuildContext context) {
    final playlistsProvider = context.read<PlaylistsProvider>();

    return showPlatformBottomSheet(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: playlistsProvider,
        builder: (context, _) => PlaylistsSheet(selectedSongLyrics: [lyricsController.songLyric]),
      ),
      height: 0.67 * MediaQuery.of(context).size.height,
    );
  }

  Future<String> _generateCustomField(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final version = '${packageInfo.version}%2b${packageInfo.buildNumber}';
    final platform = AppTheme.of(context).isIOS ? 'iOS' : 'android';

    return '${lyricsController.songLyric.id}+$version+$platform';
  }
}
