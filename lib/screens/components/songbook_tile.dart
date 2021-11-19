import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/platform/utils/route_builder.dart';
import 'package:zpevnik/providers/songbooks.dart';
import 'package:zpevnik/screens/components/highlightable.dart';
import 'package:zpevnik/screens/songbook/songbook.dart';
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

class SongbookTile extends StatefulWidget {
  final Songbook songbook;

  const SongbookTile({Key? key, required this.songbook}) : super(key: key);

  @override
  _SongbookTileState createState() => _SongbookTileState();
}

class _SongbookTileState extends State<SongbookTile> {
  final pinHighlightablKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Highlightable(
      onPressed: _pushSongbook,
      child: Column(children: [_songbookLogo(context), _songbookInfo(context)]),
      highlightableChildKey: pinHighlightablKey,
    );
  }

  Widget _songbookLogo(BuildContext context) {
    final shortcut = widget.songbook.shortcut.toLowerCase();
    final imagePath = _existingLogos.contains(shortcut) ? '$_logosPath/$shortcut.png' : '$_logosPath/default.png';

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: FittedBox(child: Image.asset(imagePath)),
      ),
    );
  }

  Widget _songbookInfo(BuildContext context) {
    final textStyle = AppTheme.of(context).bodyTextStyle;
    final songbook = widget.songbook;

    final songbooksProvider = context.read<SongbooksProvider>();

    return Container(
      padding: EdgeInsets.only(top: kDefaultPadding / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: AutoSizeText(songbook.name, style: textStyle, maxLines: 2)),
          Transform.scale(
            scale: 0.75,
            child: Highlightable(
              key: pinHighlightablKey,
              onPressed: () => setState(() => songbooksProvider.toggleIsPinned(songbook)),
              child: Icon(songbook.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            ),
          ),
        ],
      ),
    );
  }

  void _pushSongbook() {
    final isLightMode = AppTheme.of(context).brightness == Brightness.light;
    final navigationBarColor = isLightMode ? HexColor.fromHex(widget.songbook.color) : null;
    final navigationBarTextColor = (widget.songbook.colorText == null || !AppTheme.of(context).isLight)
        ? null
        : HexColor.fromHex(widget.songbook.colorText);

    Navigator.of(context).push(platformRouteBuilder(
      context,
      SongbookScreen(
        songbook: widget.songbook,
        navigationBarColor: navigationBarColor,
        navigationBarTextColor: navigationBarTextColor,
      ),
      types: [ProviderType.data, ProviderType.fullScreen, ProviderType.playlist, ProviderType.songbook],
    ));
  }
}
