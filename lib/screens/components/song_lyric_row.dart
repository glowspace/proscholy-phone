import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/selection_provider.dart';
import 'package:zpevnik/screens/components/circular_checkbox.dart';
import 'package:zpevnik/screens/components/highlightable_row.dart';
import 'package:zpevnik/screens/song_lyric/song_lyric_screen.dart';
import 'package:zpevnik/screens/components/data_container.dart';
import 'package:zpevnik/theme.dart';

class SongLyricRow extends StatefulWidget {
  final SongLyric songLyric;
  final bool showStar;
  final Widget prefix;

  const SongLyricRow({Key key, @required this.songLyric, this.showStar = true, this.prefix}) : super(key: key);

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

    return GestureDetector(
      onLongPress: selectionProvider == null ? null : () => selectionProvider.toggleSongLyric(widget.songLyric),
      behavior: HitTestBehavior.translucent,
      child: HighlightableRow(
        onPressed: () =>
            selectionEnabled ? selectionProvider.toggleSongLyric(widget.songLyric) : _pushSongLyric(context),
        color: selected ? AppThemeNew.of(context).selectedRowColor : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.prefix != null)
              Container(padding: EdgeInsets.only(right: kDefaultPadding), child: widget.prefix),
            if (songbookContainer != null)
              Container(
                padding: EdgeInsets.only(right: kDefaultPadding),
                child: _songLyricNumber(context, widget.songLyric.number(songbookContainer.data)),
              ),
            if (selectionEnabled)
              Container(padding: EdgeInsets.only(right: kDefaultPadding), child: CircularCheckbox(selected: selected)),
            Expanded(child: Text(widget.songLyric.name, style: AppThemeNew.of(context).bodyTextStyle)),
            if (widget.showStar && widget.songLyric.isFavorite)
              Icon(Icons.star, color: AppThemeNew.of(context).iconColor, size: 16),
            _songLyricNumber(context, widget.songLyric.id.toString()),
          ],
        ),
      ),
    );
  }

  Widget _songLyricNumber(BuildContext context, String number) => SizedBox(
        width: 36,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(number, style: AppThemeNew.of(context).captionTextStyle),
        ),
      );

  void _pushSongLyric(BuildContext context) {
    FocusScope.of(context).unfocus();

    // if selecte songLyric is already in context pop back to it (used for translation screen)
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
