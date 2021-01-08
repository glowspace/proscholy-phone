import 'package:flutter/material.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/playlists_provider.dart';
import 'package:zpevnik/screens/components/bottom_form_sheet.dart';
import 'package:zpevnik/screens/components/menu_item.dart';

class PlaylistSheet extends StatefulWidget {
  final List<SongLyric> songLyrics;

  const PlaylistSheet({Key key, this.songLyrics}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlaylistSheetState();
}

class _PlaylistSheetState extends State<PlaylistSheet> {
  @override
  initState() {
    super.initState();

    PlaylistsProvider.shared.addListener(_update);
  }

  @override
  Widget build(BuildContext context) => BottomFormSheet(
        title: 'Playlisty',
        items: [
          MenuItem(
            title: 'Nový playlist',
            icon: Icons.add,
            onPressed: () => PlaylistsProvider.shared.showPlaylistDialog(context),
          ),
          for (final playlist in PlaylistsProvider.shared.playlists)
            MenuItem(
              title: playlist.name,
              onPressed: () {
                playlist.addSongLyrics(widget.songLyrics);
                Navigator.pop(context);
              },
            ),
        ],
      );

  void _update() => setState(() {});

  @override
  void dispose() {
    PlaylistsProvider.shared.removeListener(_update);

    super.dispose();
  }
}
