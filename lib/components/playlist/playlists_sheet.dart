import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/icon_item.dart';
import 'package:zpevnik/components/playlist/dialogs.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/navigation.dart';

class PlaylistsSheet extends StatelessWidget {
  final SongLyric selectedSongLyric;

  const PlaylistsSheet({Key? key, required this.selectedSongLyric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playlists = context.watch<DataProvider>().playlists;

    return SafeArea(
      top: false,
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(kDefaultPadding).copyWith(bottom: kDefaultPadding / 2),
            child: Text('Playlisty', style: Theme.of(context).textTheme.titleLarge),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HighlightableTextButton(
                  onTap: () => showPlaylistDialog(context),
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
                  icon: const Icon(Icons.add, size: 20),
                  child: const Text('Nový playlist'),
                ),
                const Divider(height: kDefaultPadding),
                ...playlists.map(
                  (playlist) => HighlightableTextButton(
                    onTap: () => _addToPlaylist(context, playlist),
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
                    icon: const Icon(Icons.playlist_play_rounded, size: 20),
                    child: Text(playlist.name),
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addToPlaylist(BuildContext context, Playlist playlist) {
    context.read<DataProvider>().addToPlaylist(selectedSongLyric, playlist);

    NavigationProvider.of(context).popAndPushNamed('/playlist', arguments: playlist);
  }
}
