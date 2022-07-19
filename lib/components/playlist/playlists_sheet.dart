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
            child: Column(children: [
              Highlightable(
                onTap: () => showPlaylistDialog(context),
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
                child: const IconItem(text: 'Nový playlist', icon: Icons.add, iconSize: 20),
              ),
              const Divider(height: kDefaultPadding),
              ...playlists.map(
                (playlist) => Highlightable(
                  onTap: () => _addToPlaylist(context, playlist),
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
                  child: IconItem(text: playlist.name, icon: Icons.playlist_play_rounded, iconSize: 20),
                ),
              ),
              const SizedBox(height: kDefaultPadding),
            ]),
          ),
        ],
      ),
    );
  }

  void _addToPlaylist(BuildContext context, Playlist playlist) {
    context.read<DataProvider>().addToPlaylist(selectedSongLyric, playlist);

    Navigator.of(context).popAndPushNamed('/playlist', arguments: playlist);
  }
}
