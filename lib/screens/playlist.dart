import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/playlist/action_button.dart';
import 'package:zpevnik/components/playlist/playlist_button.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_list_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/utils/search.dart';

class PlaylistScreen extends StatelessWidget {
  final Playlist playlist;

  const PlaylistScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final dataProvider = context.watch<DataProvider>();

    final Widget floatingActionButton;

    if (playlist.isFavorites) {
      floatingActionButton = FloatingActionButton(
        backgroundColor: Theme.of(context).canvasColor,
        child: const Icon(Icons.playlist_add),
        onPressed: () => _addSongLyric(context),
      );
    } else {
      floatingActionButton = SpeedDial(
        icon: Icons.playlist_add,
        backgroundColor: Theme.of(context).canvasColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultRadius)),
        overlayOpacity: 0.0, // overlay will be invisible, but will allow closing the dial by tapping anywhere on screen
        children: [
          PlaylistActionButton(
            label: 'vlastní text',
            icon: Icons.format_align_justify,
          ),
          PlaylistActionButton(
            label: 'biblický úryvek',
            icon: Icons.book,
          ),
          PlaylistActionButton(
            label: 'píseň',
            icon: FontAwesomeIcons.music,
            onTap: () => _addSongLyric(context),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(playlist.name),
        actions: [if (!playlist.isFavorites) PlaylistButton(playlist: playlist, isInAppBar: true)],
      ),
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => PlaylistSongLyricsProvider(dataProvider, playlist),
          builder: (_, __) => const SongLyricsListView<PlaylistSongLyricsProvider>(),
        ),
      ),
    );
  }

  void _addSongLyric(BuildContext context) async {
    final songLyric = await Navigator.of(context).pushNamed(
      '/search',
      arguments: SearchScreenArguments(shouldReturnSongLyric: true),
    );

    if (songLyric != null && songLyric is SongLyric) context.read<DataProvider>().addToPlaylist(songLyric, playlist);
  }

  void _maybePushMatchedSonglyric(BuildContext context) {
    final songLyricsProvider = context.read<PlaylistSongLyricsProvider>();

    if (songLyricsProvider.matchedById != null) {
      Navigator.pushNamed(context, '/song_lyric', arguments: songLyricsProvider.matchedById);
    }
  }
}
