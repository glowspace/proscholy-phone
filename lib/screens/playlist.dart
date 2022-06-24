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
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: const SongLyricsListView<PlaylistSongLyricsProvider>(),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(kDefaultRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Highlightable(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Icon(Icons.playlist_add),
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
