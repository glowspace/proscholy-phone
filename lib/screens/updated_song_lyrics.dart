import 'package:flutter/material.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_list_view.dart';
import 'package:zpevnik/models/song_lyric.dart';

class UpdatedSongLyricsScreen extends StatelessWidget {
  final List<SongLyric> songLyrics;

  const UpdatedSongLyricsScreen({super.key, required this.songLyrics});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(leading: const CustomBackButton(), title: const Text('Naposledy aktualizované')),
      body: SafeArea(child: SongLyricsListView(songLyrics: songLyrics)),
    );
  }
}
