import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/providers/playlists_provider.dart';
import 'package:zpevnik/screens/components/data_container.dart';
import 'package:zpevnik/screens/components/menu_item.dart';
import 'package:zpevnik/screens/components/popup_menu.dart';
import 'package:zpevnik/screens/song_lyric/music_notes_screen.dart';
import 'package:zpevnik/theme.dart';

class SongLyricMenu extends StatelessWidget {
  final ValueNotifier<bool> showing;

  const SongLyricMenu({Key key, this.showing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songLyric = DataContainer.of<SongLyric>(context).data;

    return PopupMenu(
      showing: showing,
      border: Border(
        left: BorderSide(color: AppTheme.of(context).borderColor),
        bottom: BorderSide(color: AppTheme.of(context).borderColor),
      ),
      children: [
        MenuItem(
          title: 'Přidat do seznamu',
          icon: Icons.playlist_add,
          onPressed: () {
            PlaylistsProvider.shared.showPlaylists(context, [songLyric]);
            showing.value = false;
          },
        ),
        // MenuItem('Zpěvníky', Icons.import_contacts, null),
        // if (songLyric.lilypond != null)
        //   MenuItem(
        //       title: 'Noty',
        //       icon: Icons.insert_drive_file,
        //       onPressed: () {
        //         Navigator.of(context).push(
        //           MaterialPageRoute(builder: (context) => MusicNotesScreen(songLyric: songLyric)),
        //         );

        //         showing.value = false;
        //       }),
        MenuItem(
          title: 'Sdílet',
          icon: Icons.share,
          onPressed: () {
            FlutterShare.share(
              title: songLyric.name,
              linkUrl: '$songUrl/${songLyric.id}/',
              chooserTitle: songLyric.name,
            );
            showing.value = false;
          },
        ),
        MenuItem(
          title: 'Otevřít na webu',
          icon: Icons.language,
          onPressed: () {
            launch('$songUrl/${songLyric.id}/');
            showing.value = false;
          },
        ),
        MenuItem(
          title: 'Nahlásit',
          icon: Icons.warning,
          onPressed: () {
            launch('$reportUrl=${songLyric.id}');
            showing.value = false;
          },
        ),
      ],
    );
  }
}
