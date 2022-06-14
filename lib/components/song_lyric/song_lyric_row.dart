import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';

const double _iconSize = 16;

class SongLyricRow extends StatelessWidget {
  final SongLyric songLyric;

  const SongLyricRow({Key? key, required this.songLyric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                const FaIcon(FontAwesomeIcons.guitar, size: _iconSize, color: blue),
                const SizedBox(width: kDefaultPadding),
                const FaIcon(FontAwesomeIcons.solidFileLines, size: _iconSize, color: red),
                const SizedBox(width: kDefaultPadding),
                const FaIcon(FontAwesomeIcons.headphones, size: _iconSize, color: green),
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
    context.read<DataProvider>().addRecentSongLyric(songLyric);

    Navigator.pushNamed(context, '/song_lyric', arguments: songLyric);
  }
}
