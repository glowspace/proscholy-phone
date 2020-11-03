import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/song_lyric_screen.dart';
import 'package:zpevnik/theme.dart';

import 'circular_checkbox.dart';

class SongLyricRow extends StatefulWidget {
  final SongLyric songLyric;
  final bool showStar;

  const SongLyricRow({Key key, this.songLyric, this.showStar = true}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongLyricRowState();
}

class _SongLyricRowState extends State<SongLyricRow> {
  bool _highlighted;

  @override
  void initState() {
    super.initState();

    _highlighted = false;

    widget.songLyric.addListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    final selectionProvider = Provider.of<SongLyricsProvider>(context, listen: false).selectionProvider;

    return GestureDetector(
      onLongPress: selectionProvider == null ? null : () => selectionProvider?.toggleSongLyric(widget.songLyric),
      onTap: () => (selectionProvider?.selectionEnabled ?? false)
          ? selectionProvider?.toggleSongLyric(widget.songLyric)
          : _pushSongLyric(context),
      onPanDown: (_) => setState(() => _highlighted = true),
      onPanCancel: () => setState(() => _highlighted = false),
      onPanEnd: (_) => setState(() => _highlighted = false),
      behavior: HitTestBehavior.translucent,
      child: Container(
        color: (selectionProvider?.isSelected(widget.songLyric) ?? false)
            ? AppTheme.shared.selectedRowBackgroundColor(context)
            : (_highlighted ? AppTheme.shared.highlightColor(context) : null),
        padding: EdgeInsets.all(2 * kDefaultPadding / 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (selectionProvider?.selectionEnabled ?? false)
              Container(
                padding: EdgeInsets.only(right: kDefaultPadding / 2),
                child: CircularCheckbox(selected: selectionProvider?.isSelected(widget.songLyric) ?? false),
              ),
            Expanded(
              child: Text(widget.songLyric.name, style: Theme.of(context).textTheme.bodyText1),
            ),
            if (widget.showStar && widget.songLyric.isFavorite)
              Container(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                child: Transform.scale(
                  scale: 0.75,
                  child: Icon(Icons.star,
                      color: (selectionProvider?.isSelected(widget.songLyric) ?? false)
                          ? AppTheme.shared.selectedRowColor(context)
                          : Theme.of(context).textTheme.caption.color),
                ),
              ),
            SizedBox(
              width: 32,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(widget.songLyric.id.toString(), style: Theme.of(context).textTheme.caption),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _pushSongLyric(BuildContext context) {
    FocusScope.of(context).unfocus();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SongLyricScreen(songLyric: widget.songLyric),
      ),
    );
  }

  void _update() => setState(() => {});

  @override
  void dispose() {
    widget.songLyric.removeListener(_update);

    super.dispose();
  }
}
