import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/playlist/playlist_button.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_list_view.dart';
import 'package:zpevnik/constants.dart';
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
      floatingActionButton: _buildFloatingActionButton(context),
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => PlaylistSongLyricsProvider(context.read<DataProvider>(), playlist),
          builder: (_, __) => const SongLyricsListView<PlaylistSongLyricsProvider>(),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultRadius),
        boxShadow: [BoxShadow(color: theme.shadowColor, blurRadius: 4, offset: const Offset(0, 3))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Highlightable(
        padding: const EdgeInsets.all(kDefaultPadding),
        highlightBackground: true,
        color: theme.colorScheme.surface,
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
