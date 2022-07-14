import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_list_view.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/song_lyrics.dart';

class UpdatedSongLyricsScreen extends StatelessWidget {
  const UpdatedSongLyricsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: const Text('Naposledy aktualizované'),
      ),
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => UpdatedSongLyricsProvider(context.read<DataProvider>()),
          builder: (_, __) => const SongLyricsListView<UpdatedSongLyricsProvider>(),
        ),
      ),
    );
  }
}
