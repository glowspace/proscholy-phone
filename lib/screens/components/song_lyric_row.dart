import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/selection_provider.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/components/circular_checkbox.dart';
import 'package:zpevnik/screens/components/highlightable_row.dart';
import 'package:zpevnik/screens/song_lyric/song_lyric_screen.dart';
import 'package:zpevnik/screens/components/data_container.dart';
import 'package:zpevnik/theme.dart';

class SongLyricRow extends StatefulWidget {
  final SongLyric songLyric;
  final bool showStar;
  final Widget prefix;
  final bool hasProvider; // fixme: temporary solution for translations

  const SongLyricRow({Key key, @required this.songLyric, this.showStar = true, this.prefix, this.hasProvider = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongLyricRowStateNew();
}

class _SongLyricRowStateNew extends State<SongLyricRow> {
  @override
  void initState() {
    super.initState();

    widget.songLyric.addListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    final selectionProvider = DataContainer.of<SelectionProvider>(context)?.data;
    final selectionEnabled = selectionProvider?.selectionEnabled ?? false;
    final selected = selectionProvider?.isSelected(widget.songLyric) ?? false;

    final songbookContainer = DataContainer.of<Songbook>(context);
    final showingNumber = songbookContainer == null
        ? (widget.hasProvider
            ? widget.songLyric.showingNumber(Provider.of<SongLyricsProvider>(context).searchText)
            : widget.songLyric.id.toString())
        : widget.songLyric.id.toString();

    final appTheme = AppTheme.of(context);

    return GestureDetector(
      onLongPress: selectionProvider == null ? null : () => selectionProvider.toggleSongLyric(widget.songLyric),
      behavior: HitTestBehavior.translucent,
      child: HighlightableRow(
        onPressed: () =>
            selectionEnabled ? selectionProvider.toggleSongLyric(widget.songLyric) : _pushSongLyric(context),
        color: selected ? appTheme.selectedRowColor : null,
        prefix: widget.prefix,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (selectionEnabled)
              Container(padding: EdgeInsets.only(right: kDefaultPadding), child: CircularCheckbox(selected: selected)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.songLyric.name, style: appTheme.bodyTextStyle.copyWith(height: 1.5)),
                  if (widget.songLyric.secondaryName != null)
                    Text(widget.songLyric.secondaryName, style: appTheme.secondaryTextStyle)
                ],
              ),
              flex: 24,
            ),
            if (widget.showStar && widget.songLyric.isFavorite) Icon(Icons.star, color: appTheme.iconColor, size: 16),
            if (songbookContainer != null)
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.only(right: 2), // just to make some minimal space between shortcut and song number
                  child: _songLyricNumber(context, songbookContainer.data.shortcut),
                ),
                flex: songbookContainer.data.shortcut.length,
              ),
            if (songbookContainer != null)
              Expanded(
                child: _songLyricNumber(context, widget.songLyric.number(songbookContainer.data)),
                flex: 3,
              )
            else
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: kDefaultPadding),
                  child: _songLyricNumber(context, showingNumber),
                ),
                flex: 4,
              )
          ],
        ),
      ),
    );
  }

  Widget _songLyricNumber(BuildContext context, String number) => FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: Text(number, style: AppTheme.of(context).captionTextStyle.copyWith(fontFamily: 'Nunito')),
      );

  void _pushSongLyric(BuildContext context) {
    FocusScope.of(context).unfocus();

    // if selected songLyric is already in context pop back to it (used for translation screen)
    if (widget.songLyric == DataContainer.of<SongLyric>(context)?.data)
      Navigator.of(context).pop();
    else
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SongLyricScreen(songLyric: widget.songLyric)));
  }

  void _update() => setState(() {});

  @override
  void dispose() {
    widget.songLyric.removeListener(_update);

    super.dispose();
  }
}
