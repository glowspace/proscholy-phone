import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/platform/components/dialog.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/components/bottom_form_sheet.dart';
import 'package:zpevnik/components/icon_item.dart';

class PlaylistsSheet extends StatefulWidget {
  final List<SongLyric> selectedSongLyrics;

  const PlaylistsSheet({Key? key, this.selectedSongLyrics = const []}) : super(key: key);

  @override
  _PlaylistsSheetState createState() => _PlaylistsSheetState();
}

class _PlaylistsSheetState extends State<PlaylistsSheet> {
  @override
  Widget build(BuildContext context) {
    return BottomFormSheet(
      title: 'Playlisty',
      contentPadding: EdgeInsets.zero,
      items: [
        IconItem(title: 'Nový playlist', icon: Icons.add, onTap: showPlaylistDialog),
        Consumer<PlaylistsProvider>(
          builder: (_, provider, __) => ListView.builder(
            itemBuilder: (context, index) => IconItem(
              title: provider.playlists[index].name,
              onTap: () {
                provider.playlists[index].addSongLyrics(widget.selectedSongLyrics);

                Navigator.pop(context);
              },
            ),
            itemCount: provider.playlists.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
      ],
    );
  }

  void showPlaylistDialog() async {
    final name = await showPlatformDialog<String>(
      context,
      (context) => PlatformDialog(title: 'Vytvořit playlist', submitText: 'Vytvořit'),
    );

    if (name != null) context.read<PlaylistsProvider>().addPlaylist(name);
  }
}
