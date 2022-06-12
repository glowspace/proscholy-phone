import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';

const double _iconSize = 18;

class SongLyricRow extends StatelessWidget {
  final SongLyric songLyric;

  const SongLyricRow({Key? key, required this.songLyric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Highlightable(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(child: Text(songLyric.name, style: textTheme.bodyMedium)),
              const SizedBox(width: kDefaultPadding / 2),
              const Icon(Icons.format_align_left, size: _iconSize, color: blue),
              const SizedBox(width: kDefaultPadding / 2),
              const Icon(Icons.insert_drive_file, size: _iconSize, color: red),
              const SizedBox(width: kDefaultPadding / 2),
              const Icon(Icons.headphones_rounded, size: _iconSize, color: green),
            ]),
            Text(songLyric.name, style: textTheme.caption),
          ],
        ),
      ),
    );
  }
}
