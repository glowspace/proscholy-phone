import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/platform/utils/bottom_sheet.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/components/icon_item.dart';
import 'package:zpevnik/components/playlists_sheet.dart';
import 'package:zpevnik/components/popup_menu.dart';
import 'package:zpevnik/screens/song_lyric/utils/lyrics_controller.dart';
import 'package:zpevnik/theme.dart';

class SongLyricMenu extends StatelessWidget {
  final LyricsController lyricsController;
  final bool isShowing;

  const SongLyricMenu({Key? key, required this.lyricsController, required this.isShowing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final songLyric = lyricsController.songLyric;

    // final projectionText = lyricsController.isProjectionEnabled ? 'Vypnout' : 'Zapnout';

    return AnimatedSlide(
      offset: isShowing ? Offset(0, 0) : Offset(0, -1),
      duration: kDefaultAnimationDuration,
      child: PopupMenu(
        border: Border(
          left: BorderSide(color: appTheme.borderColor),
          bottom: BorderSide(color: appTheme.borderColor),
        ),
        children: [
          IconItem(
            title: 'Přidat do seznamu',
            icon: Icons.playlist_add,
            onTap: () => _doAndHide(context, () => _showPlaylists(context)),
          ),
          // IconItem(
          //   title: 'Připojit k zařízením v okolí',
          //   icon: Icons.tap_and_play,
          //   onTap: () {
          //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConnectionsScreen()));
          //     isShowing.value = true;
          //   },
          // ),
          // IconItem(
          //   title: '$projectionText prezentační mód',
          //   icon: Icons.pages,
          //   onTap: () => _doAndHide(context, lyricsController.toggleisProjectionEnabled),
          // ),
          IconItem(
            title: 'Sdílet',
            icon: Icons.share,
            onTap: () => _doAndHide(context, () => Share.share('$songUrl/${songLyric.id}/')),
          ),
          IconItem(
            title: 'Otevřít na webu',
            icon: Icons.language,
            onTap: () => _doAndHide(context, () => launch('$songUrl/${songLyric.id}/')),
          ),
          IconItem(
            title: 'Nahlásit',
            icon: Icons.warning,
            onTap: () =>
                _doAndHide(context, () async => launch('$reportUrl?customfield_10056=${await _generateCustomField()}')),
          ),
        ],
      ),
    );
  }

  void _doAndHide(BuildContext context, Function() func) {
    func();

    // isShowing.value = true;
  }

  void _showPlaylists(BuildContext context) {
    final playlistsProvider = context.read<PlaylistsProvider>();

    showPlatformBottomSheet(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: playlistsProvider,
        builder: (context, _) => PlaylistsSheet(selectedSongLyrics: [lyricsController.songLyric]),
      ),
      height: 0.67 * MediaQuery.of(context).size.height,
    );
  }

  Future<String> _generateCustomField() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final version = '${packageInfo.version}%2b${packageInfo.buildNumber}';
    final platform = Platform.isIOS ? 'iOS' : 'android';

    return '${lyricsController.songLyric.id}+$version+$platform';
  }
}
