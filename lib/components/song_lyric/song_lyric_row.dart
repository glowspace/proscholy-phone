import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook_record.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/routes/arguments/search.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';

const double _iconSize = 16;
const _disabledAlpha = 0x20;

const double _minSize = 34;

class SongLyricRow extends StatelessWidget {
  final SongLyric songLyric;
  final bool isReorderable;

  // arguments that hold song lyrics that are accessible through swiping on song lyrics screen
  final SongLyricScreenArguments? songLyricScreenArguments;

  const SongLyricRow({
    Key? key,
    required this.songLyric,
    this.isReorderable = false,
    this.songLyricScreenArguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final dragIndicatorKey = GlobalKey();

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

    final row = Highlightable(
      highlightBackground: true,
      highlightableChildKeys: [dragIndicatorKey],
      onTap: () => _pushSongLyric(context),
      padding: EdgeInsets.fromLTRB(
        isReorderable ? 0 : 1.5 * kDefaultPadding,
        kDefaultPadding / 3,
        1.5 * kDefaultPadding,
        kDefaultPadding / 3,
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: _minSize),
        child: Row(
          children: [
            if (isReorderable)
              ReorderableDragStartListener(
                key: dragIndicatorKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
                  child: const Icon(Icons.drag_indicator),
                ),
                index: 0,
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

    final songLyricsProvider = context.read<PlaylistSongLyricsProvider?>();

    if (songLyricsProvider != null && !songLyricsProvider.playlist.isFavorites) {
      return Dismissible(
        key: Key('${songLyric.id}'),
        onDismissed: (_) => songLyricsProvider.removeSongLyric(songLyric),
        direction: DismissDirection.endToStart,
        background: Container(color: red),
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
