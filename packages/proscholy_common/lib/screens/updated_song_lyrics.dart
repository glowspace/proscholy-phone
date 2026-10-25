import 'package:flutter/material.dart';
import 'package:proscholy_common/components/custom/back_button.dart';
import 'package:proscholy_common/components/navigation/scaffold.dart';
import 'package:proscholy_common/components/song_lyric/song_lyrics_list_view.dart';
import 'package:proscholy_common/models/song_lyric.dart';

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
