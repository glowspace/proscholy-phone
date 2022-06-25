import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/icon_item.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';

class PlaylistsSheet extends StatefulWidget {
  final List<SongLyric> selectedSongLyrics;

  const PlaylistsSheet({Key? key, this.selectedSongLyrics = const []}) : super(key: key);

  @override
  _PlaylistsSheetState createState() => _PlaylistsSheetState();
}

class _PlaylistsSheetState extends State<PlaylistsSheet> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.all(kDefaultPadding).copyWith(bottom: kDefaultPadding / 2),
          child: Text('Playlisty', style: Theme.of(context).textTheme.titleLarge),
        ),
        SingleChildScrollView(
          child: Column(children: [
            Highlightable(
              onTap: showPlaylistDialog,
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
              child: const IconItem(text: 'Nový playlist', icon: Icons.add),
            ),
            const SizedBox(height: kDefaultPadding),
          ]),
        ),
      ],
    );
  }

  void showPlaylistDialog() async {
    // final name = await showPlatformDialog<String>(
    //   context,
    //   (context) => PlatformDialog(title: 'Vytvořit playlist', submitText: 'Vytvořit'),
    // );

    // if (name != null) context.read<PlaylistsProvider>().addPlaylist(name);
  }
}
