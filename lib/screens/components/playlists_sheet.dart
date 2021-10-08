import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/platform/components/dialog.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/screens/components/bottom_form_sheet.dart';
import 'package:zpevnik/screens/components/icon_item.dart';

class PlaylistsSheet extends StatefulWidget {
  final List<SongLyric> selectedSongLyrics;

  const PlaylistsSheet({Key? key, this.selectedSongLyrics = const []}) : super(key: key);

  @override
  _PlaylistsSheetState createState() => _PlaylistsSheetState();
}

class _PlaylistsSheetState extends State<PlaylistsSheet> {
  @override
  Widget build(BuildContext context) {
    final playlistsProvider = context.watch<PlaylistsProvider>();

    return BottomFormSheet(
      title: 'Playlisty',
      contentPadding: EdgeInsets.zero,
      items: [
        IconItem(title: 'Nový playlist', icon: Icons.add, onPressed: showPlaylistDialog),
        for (final playlist in playlistsProvider.allPlaylists)
          IconItem(
            title: playlist.name,
            onPressed: () {
              playlist.addSongLyrics(widget.selectedSongLyrics);

              Navigator.pop(context);
            },
          ),
      ],
    );
  }

  void showPlaylistDialog() {
    final playlistsProvider = context.read<PlaylistsProvider>();

    showPlatformDialog<String>(
      context,
      (context) => PlatformDialog(title: 'Vytvořit playlist', submitText: 'Vytvořit'),
    ).then((text) {
      if (text != null) playlistsProvider.addPlaylist(text);
    });
  }
}
