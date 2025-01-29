import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proscholy_common/components/bottom_sheet_section.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/components/playlist/dialogs.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/playlists.dart';
import 'package:proscholy_common/utils/extensions.dart';

class PlaylistsSheet extends StatelessWidget {
  final SongLyric selectedSongLyric;

  const PlaylistsSheet({super.key, required this.selectedSongLyric});

  @override
  Widget build(BuildContext context) {
    return BottomSheetSection(
      title: 'Playlisty',
      tip: 'Vyberte existující playlist nebo si vytvořte nový.',
      childrenPadding: false,
      children: [
        Consumer(
          builder: (context, ref, __) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HighlightableWidget(
                onTap: () => showPlaylistDialog(context, selectedSongLyric: selectedSongLyric),
                padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
                icon: const Icon(Icons.add),
                child: const Padding(
                  padding: EdgeInsets.only(left: kDefaultPadding / 3), // align it with playlist rows
                  child: Text('Nový playlist'),
                ),
              ),
              const SizedBox(height: kDefaultPadding / 2),
              const Divider(),
              ...[
                for (final playlist in ref.watch(playlistsProvider))
                  HighlightableWidget(
                    onTap: () => _addToPlaylist(context, playlist),
                    highlightBackground: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 1.5 * kDefaultPadding,
                      vertical: 2 * kDefaultPadding / 3,
                    ),
                    child: Row(children: [
                      const Icon(Icons.playlist_play_rounded),
                      const SizedBox(width: kDefaultPadding),
                      Text(playlist.name),
                    ]),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _addToPlaylist(BuildContext context, Playlist playlist) {
    context.providers.read(playlistsProvider.notifier).addToPlaylist(playlist, songLyric: selectedSongLyric);

    context.popAndPush('/playlist', arguments: playlist);
  }
}
