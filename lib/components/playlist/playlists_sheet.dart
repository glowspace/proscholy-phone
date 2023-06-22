import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/playlist/dialogs.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/routing/router.dart';

class PlaylistsSheet extends StatelessWidget {
  final SongLyric selectedSongLyric;

  const PlaylistsSheet({super.key, required this.selectedSongLyric});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(kDefaultPadding, kDefaultPadding, kDefaultPadding, kDefaultPadding / 2),
          child: Text('Playlisty', style: Theme.of(context).textTheme.titleLarge),
        ),
        SingleChildScrollView(
          child: Consumer(
            builder: (context, ref, __) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HighlightableTextButton(
                  onTap: () => showPlaylistDialog(context, ref),
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
                  icon: const Icon(Icons.add, size: 20),
                  child: const Text('Nový playlist'),
                ),
                const Divider(height: kDefaultPadding),
                ...[
                  for (final playlist in ref.watch(playlistsProvider))
                    Consumer(
                      builder: (context, ref, __) => HighlightableTextButton(
                        onTap: () => _addToPlaylist(context, ref, playlist),
                        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
                        icon: const Icon(Icons.playlist_play_rounded, size: 20),
                        child: Text(playlist.name),
                      ),
                    ),
                ],
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _addToPlaylist(BuildContext context, WidgetRef ref, Playlist playlist) {
    ref.read(playlistsProvider.notifier).addToPlaylist(playlist, selectedSongLyric);

    context.popAndPush('/playlist', extra: playlist);
  }
}
