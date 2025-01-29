import 'package:flutter/material.dart';
import 'package:proscholy_common/components/song_lyric/song_lyric_row.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/songbook.dart';
import 'package:proscholy_common/routing/arguments.dart';

class SongLyricsListView extends StatelessWidget {
  final List<SongLyric> songLyrics;
  final Songbook? songbook;

  const SongLyricsListView({super.key, required this.songLyrics, this.songbook});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      padding: const EdgeInsets.only(top: kDefaultPadding / 3),
      itemCount: songLyrics.length,
      itemBuilder: (_, index) => SongLyricRow(
        songLyric: songLyrics[index],
        displayScreenArguments: DisplayScreenArguments(items: songLyrics, initialIndex: index, songbook: songbook),
      ),
    );
  }
}
