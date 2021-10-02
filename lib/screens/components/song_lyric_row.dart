import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/platform/utils/route_builder.dart';
import 'package:zpevnik/providers/selection.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/screens/components/circular_checkbox.dart';
import 'package:zpevnik/screens/components/highlightable.dart';
import 'package:zpevnik/screens/components/reorderable_row.dart';
import 'package:zpevnik/screens/song_lyric/song_lyric.dart';
import 'package:zpevnik/screens/utils/status_bar_wrapper.dart';
import 'package:zpevnik/theme.dart';

class SongLyricRow extends StatefulWidget {
  final SongLyric songLyric;
  final String? searchText;
  final Songbook? songbook;
  final SongLyric? translationSongLyric;
  final bool isReorderable;

  const SongLyricRow({
    Key? key,
    required this.songLyric,
    this.searchText,
    this.songbook,
    this.translationSongLyric,
    this.isReorderable = false,
  }) : super(key: key);

  @override
  _SongLyricRowState createState() => _SongLyricRowState();
}

class _SongLyricRowState extends State<SongLyricRow> {
  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    final songLyric = widget.songLyric;
    final songbook = widget.songbook;

    final selectionProvider = context.watch<SelectionProvider?>();
    final isSelectionEnabled = selectionProvider?.isSelectionEnabled ?? false;
    final isSelected = selectionProvider?.isSelected(songLyric) ?? false;

    final child = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isSelectionEnabled)
          Container(
            padding: EdgeInsets.only(right: kDefaultPadding),
            child: CircularCheckbox(selected: isSelected),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(songLyric.name, style: appTheme.bodyTextStyle),
              if (songLyric.secondaryName != null) Text(songLyric.secondaryName!, style: appTheme.captionTextStyle)
            ],
          ),
          flex: 24,
        ),
        if (songbook != null) Expanded(child: _songLyricNumber(songbook.shortcut), flex: songbook.shortcut.length),
        Expanded(child: _songLyricNumber(songLyric.number(songbook)), flex: 3),
      ],
    );

    if (widget.isReorderable) return ReorderableRow(key: widget.songLyric.key, child: child, onPressed: _pushSongLyric);

    return Highlightable(
      onPressed: _pushSongLyric,
      onLongPressed: _enableSelection,
      color: isSelected ? appTheme.selectedRowColor : Colors.transparent,
      child: child,
    );
  }

  Widget _songLyricNumber(String number) {
    final textStyle = AppTheme.of(context).captionTextStyle?.copyWith(fontFamily: 'Nunito');

    return FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerRight, child: Text(number, style: textStyle));
  }

  void _pushSongLyric() async {
    final selectionProvider = context.read<SelectionProvider?>();
    final isSelectionEnabled = selectionProvider?.isSelectionEnabled ?? false;

    if (isSelectionEnabled) {
      selectionProvider?.toggleSelected(widget.songLyric);
      return;
    }

    if (widget.translationSongLyric?.id == widget.songLyric.id)
      Navigator.of(context).pop();
    else {
      StatusBarWrapper.of(context).navigationBarColor.value = null;

      context.read<SongLyricsProvider>().currentSongLyric = widget.songLyric;

      Navigator.of(context).push(platformRouteBuilder(
        context,
        SongLyricScreen(songLyric: widget.songLyric, fromTranslations: widget.translationSongLyric != null),
        types: [ProviderType.data, ProviderType.fullScreen, ProviderType.playlist, ProviderType.songLyric],
      ));
    }
  }

  void _enableSelection() {
    final selectionProvider = context.read<SelectionProvider?>();

    final isSelectionEnabled = selectionProvider?.isSelectionEnabled ?? false;

    if (isSelectionEnabled) return;

    selectionProvider?.isSelectionEnabled = true;
    selectionProvider?.toggleSelected(widget.songLyric);
  }
}
