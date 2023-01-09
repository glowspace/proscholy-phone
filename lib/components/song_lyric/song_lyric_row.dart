import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/routes/arguments/search.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';
import 'package:zpevnik/utils/extensions.dart';

const double _iconSize = 16;
const _disabledAlpha = 0x20;

const double _minSize = 34;

class SongLyricRow extends StatelessWidget {
  final SongLyric songLyric;
  final bool isReorderable;
  final bool isDraggable;
  final bool allowHighlight;

  // arguments that hold song lyrics that are accessible through swiping on song lyrics screen
  final SongLyricScreenArguments? songLyricScreenArguments;

  const SongLyricRow({
    Key? key,
    required this.songLyric,
    this.isReorderable = false,
    this.songLyricScreenArguments,
    this.isDraggable = false,
    this.allowHighlight = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    String? songbookName;

    final searchText = context.read<AllSongLyricsProvider?>()?.searchText;

    if (searchText != null && searchText.isNotEmpty) {
      for (final songbookRecord in songLyric.songbookRecords) {
        if (searchText == songbookRecord.number) {
          songbookName = songbookRecord.songbook.target!.name;

          break;
        }
      }
    }

    const textMargin = EdgeInsets.only(top: 2);

    final hightlightColor = theme.brightness.isLight ? const Color(0xffe8e6ef) : const Color(0xff15131d);

    final isTablet = MediaQuery.of(context).isTablet;

    Widget row = InkWell(
      onTap: () => _pushSongLyric(context),
      child: Container(
        constraints: const BoxConstraints(minHeight: _minSize),
        padding: isTablet && allowHighlight
            ? EdgeInsets.symmetric(horizontal: isReorderable ? 0 : kDefaultPadding, vertical: kDefaultPadding / 3)
            : EdgeInsets.fromLTRB(
                isReorderable ? kDefaultPadding : 1.5 * kDefaultPadding,
                kDefaultPadding / 3,
                1.5 * kDefaultPadding,
                kDefaultPadding / 3,
              ),
        child: Row(
          children: [
            if (isReorderable)
              ReorderableDragStartListener(
                index: 0,
                child: Container(
                  padding: const EdgeInsets.only(left: kDefaultPadding, right: 2 * kDefaultPadding),
                  child: const Icon(Icons.drag_indicator),
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(songLyric.name, style: textTheme.bodyMedium),
                  if (songbookName != null)
                    Container(margin: textMargin, child: Text(songbookName, style: textTheme.bodySmall)),
                  if (songLyric.secondaryName1 != null)
                    Container(margin: textMargin, child: Text(songLyric.secondaryName1!, style: textTheme.bodySmall)),
                  if (songLyric.secondaryName2 != null)
                    Container(margin: textMargin, child: Text(songLyric.secondaryName2!, style: textTheme.bodySmall)),
                ],
              ),
            ),
            if (!isReorderable) ..._buildIndicators(context),
          ],
        ),
      ),
    );

    if (isTablet && allowHighlight) {
      row = ValueListenableBuilder<SongLyric?>(
        valueListenable: context.read<ValueNotifier<SongLyric?>>(),
        builder: (_, activeSongLyric, child) => Container(
          decoration: activeSongLyric == songLyric
              ? BoxDecoration(color: hightlightColor, borderRadius: BorderRadius.circular(kDefaultRadius))
              : BoxDecoration(borderRadius: BorderRadius.circular(kDefaultRadius)),
          margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          clipBehavior: Clip.antiAlias,
          child: child!,
        ),
        child: row,
      );
    }

    final songLyricsProvider = context.read<PlaylistSongLyricsProvider?>();

    // SlidableAuto

    if (songLyricsProvider != null) {
      return Slidable(
        key: Key('${songLyric.id}'),
        groupTag: 'song_lyric',
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (_) => songLyricsProvider.removeSongLyric(songLyric),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Odstranit',
            ),
          ],
        ),
        child: row,
      );
    }

    if (isDraggable) {
      return Draggable(
        data: songLyric,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        affinity: Axis.horizontal,
        rootOverlay: true,
        feedback: Opacity(
          opacity: 0.75,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Text(songLyric.name),
            ),
          ),
        ),
        child: row,
      );
    }

    return row;
  }

  List<Widget> _buildIndicators(BuildContext context) {
    final theme = Theme.of(context);

    final blueScheme = ColorScheme.fromSeed(seedColor: blue, brightness: theme.brightness);
    final redScheme = ColorScheme.fromSeed(seedColor: red, brightness: theme.brightness);
    final greenScheme = ColorScheme.fromSeed(seedColor: green, brightness: theme.brightness);

    return [
      const SizedBox(width: kDefaultPadding),
      FaIcon(
        songLyric.hasChords ? FontAwesomeIcons.guitar : FontAwesomeIcons.alignLeft,
        size: _iconSize,
        color: blueScheme.primary.withAlpha(songLyric.hasLyrics ? 0xFF : _disabledAlpha),
      ),
      const SizedBox(width: kDefaultPadding),
      FaIcon(
        FontAwesomeIcons.solidFileLines,
        size: _iconSize,
        color: redScheme.primary.withAlpha(songLyric.hasFiles ? 0xFF : _disabledAlpha),
      ),
      const SizedBox(width: kDefaultPadding),
      FaIcon(
        FontAwesomeIcons.headphones,
        size: _iconSize,
        color: greenScheme.primary.withAlpha(songLyric.hasRecordings ? 0xFF : _disabledAlpha),
      ),
    ];
  }

  void _pushSongLyric(BuildContext context) {
    FocusScope.of(context).unfocus();

    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is SearchScreenArguments && arguments.shouldReturnSongLyric) {
      Navigator.of(context).pop(songLyric);
    } else {
      context.read<AllSongLyricsProvider?>()?.addRecentSongLyric(songLyric);

      final arguments = songLyricScreenArguments ?? SongLyricScreenArguments([songLyric], 0);

      NavigationProvider.of(context).pushNamed('/song_lyric', arguments: arguments);
    }
  }
}
