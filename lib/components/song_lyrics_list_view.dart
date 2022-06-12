import 'package:flutter/material.dart';
import 'package:zpevnik/components/song_lyric_row.dart';
import 'package:zpevnik/models/song_lyric.dart';

class SongLyricsListView extends StatelessWidget {
  final List<SongLyric> songLyrics;

  const SongLyricsListView({Key? key, required this.songLyrics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songLyrics.length,
      itemBuilder: (_, index) => SongLyricRow(songLyric: songLyrics[index]),
    );
  }
}
