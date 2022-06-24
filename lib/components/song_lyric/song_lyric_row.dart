import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/song_lyrics.dart';

const double _iconSize = 16;
const _disabledAlpha = 0x20;

class SongLyricRow extends StatelessWidget {
  final SongLyric songLyric;

  const SongLyricRow({Key? key, required this.songLyric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final blueScheme = theme.colorScheme;
    final redScheme = ColorScheme.fromSeed(seedColor: red, brightness: theme.brightness);
    final greenScheme = ColorScheme.fromSeed(seedColor: green, brightness: theme.brightness);

    return Highlightable(
      onTap: () => _pushSongLyric(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(songLyric.name, style: textTheme.bodyMedium)),
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
              ],
            ),
            if (songLyric.secondaryName1 != null) Text(songLyric.secondaryName1!, style: textTheme.caption),
            if (songLyric.secondaryName2 != null) Text(songLyric.secondaryName2!, style: textTheme.caption),
          ],
        ),
      ),
    );
  }

  void _pushSongLyric(BuildContext context) {
    FocusScope.of(context).unfocus();

    context.read<AllSongLyricsProvider?>()?.addRecentSongLyric(songLyric);

    Navigator.pushNamed(context, '/song_lyric', arguments: songLyric);
  }
}
