import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/playlist/playlist_button.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_list_view.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/song_lyrics.dart';

class PlaylistScreen extends StatelessWidget {
  final Playlist playlist;

  const PlaylistScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(playlist.name),
        actions: [PlaylistButton(playlist: playlist, isInAppBar: true)],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).canvasColor,
        child: const Icon(Icons.playlist_add),
        onPressed: () => {},
      ),
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => PlaylistSongLyricsProvider(context.read<DataProvider>(), playlist),
          builder: (_, __) => const SongLyricsListView<PlaylistSongLyricsProvider>(),
        ),
      ),
    );
  }

  void _maybePushMatchedSonglyric(BuildContext context) {
    final songLyricsProvider = context.read<PlaylistSongLyricsProvider>();

    if (songLyricsProvider.matchedById != null) {
      Navigator.pushNamed(context, '/song_lyric', arguments: songLyricsProvider.matchedById);
    }
  }
}
