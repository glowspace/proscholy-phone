import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/platform/utils/route_builder.dart';
import 'package:zpevnik/providers/songbooks.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/screens/songbook.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/hex_color.dart';

const _logosPath = '$imagesPath/songbooks';
const _existingLogos = [
  '1ch',
  '2ch',
  '3ch',
  '4ch',
  '5ch',
  '6ch',
  '7ch',
  '8ch',
  '9ch',
  'c',
  'csach',
  'csatr',
  'csmom',
  'csmta',
  'csmzd',
  'dbl',
  'k',
  'kan',
  'sdmkr',
  'h1',
  'h2'
];

class SongbookTile extends StatelessWidget {
  final Songbook songbook;

  SongbookTile({Key? key, required this.songbook}) : super(key: key);

  final pinHighlightablKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Highlightable(
      onTap: () => _pushSongbook(context),
      child: Column(children: [_buildSongbookLogo(context), _buildSongbookInfo(context)]),
      highlightableChildKey: pinHighlightablKey,
      padding: const EdgeInsets.all(kDefaultPadding / 2),
    );
  }

  Widget _buildSongbookLogo(BuildContext context) {
    final shortcut = songbook.shortcut.toLowerCase();
    final imagePath = _existingLogos.contains(shortcut) ? '$_logosPath/$shortcut.png' : '$_logosPath/default.png';

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: FittedBox(child: Image.asset(imagePath)),
      ),
    );
  }

  Widget _buildSongbookInfo(BuildContext context) {
    final textStyle = AppTheme.of(context).bodyTextStyle;

    final songbooksProvider = context.read<SongbooksProvider>();

    return Container(
      padding: const EdgeInsets.only(top: kDefaultPadding / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: AutoSizeText(songbook.name, style: textStyle, maxLines: 2)),
          Transform.scale(
            scale: 0.75,
            child: Highlightable(
              key: pinHighlightablKey,
              onTap: () => songbooksProvider.toggleIsPinned(songbook),
              child: Icon(songbook.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  void _pushSongbook(BuildContext context) {
    // TODO: this checks could be move somewhere else
    final isLightMode = AppTheme.of(context).brightness == Brightness.light;
    final navigationBarColor = isLightMode ? HexColor.fromHex(songbook.color) : null;
    final navigationBarTextColor =
        (songbook.colorText == null || !AppTheme.of(context).isLight) ? null : HexColor.fromHex(songbook.colorText);

    NavigationProvider.navigatorOf(context).push(platformRouteBuilder(
      context,
      SongbookScreen(
        songbook: songbook,
        navigationBarColor: navigationBarColor,
        navigationBarTextColor: navigationBarTextColor,
      ),
      types: [ProviderType.data, ProviderType.fullScreen, ProviderType.playlist, ProviderType.songbook],
    ));
  }
}
