import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_list_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/song_lyrics.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songLyricsProvider = context.read<PlaylistSongLyricsProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(songLyricsProvider.playlist.name),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      body: const SafeArea(child: SongLyricsListView<PlaylistSongLyricsProvider>()),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultRadius),
        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(0, 3))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Highlightable(
        padding: const EdgeInsets.all(kDefaultPadding),
        highlightBackground: true,
        color: Theme.of(context).colorScheme.surface,
        child: const Icon(Icons.playlist_add),
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
