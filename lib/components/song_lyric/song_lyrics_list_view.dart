import 'package:flutter/material.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_row.dart';
import 'package:zpevnik/models/song_lyric.dart';

class SongLyricsListView extends StatelessWidget {
  final List<SongLyric> songLyrics;

  const SongLyricsListView({super.key, required this.songLyrics});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      itemCount: songLyrics.length,
      itemBuilder: (_, index) => SongLyricRow(songLyric: songLyrics[index]),
    );
  }
}
