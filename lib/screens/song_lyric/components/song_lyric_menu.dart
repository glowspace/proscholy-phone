import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/providers/playlists_provider.dart';
import 'package:zpevnik/screens/components/higlightable_row.dart';
import 'package:zpevnik/screens/components/popup_menu.dart';
import 'package:zpevnik/screens/song_lyric/music_notes_screen.dart';
import 'package:zpevnik/theme.dart';

class SongLyricMenu extends StatelessWidget {
  final SongLyric songLyric;
  final ValueNotifier<bool> showing;

  const SongLyricMenu({Key key, this.songLyric, this.showing}) : super(key: key);

  @override
  Widget build(BuildContext context) => PopupMenu(
        showing: showing,
        border: Border(
          left: BorderSide(color: AppTheme.shared.borderColor(context)),
          bottom: BorderSide(color: AppTheme.shared.borderColor(context)),
        ),
        children: [
          HighlightableRow(
            title: 'Přidat do seznamu',
            icon: Icons.playlist_add,
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
            onPressed: () => PlaylistsProvider.shared.showPlaylists(context, [songLyric]),
          ),
          // HighlightableRow('Zpěvníky', Icons.import_contacts, null),
          if (songLyric.lilypond != null)
            HighlightableRow(
              title: 'Noty',
              icon: Icons.insert_drive_file,
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MusicNotesScreen(songLyric: songLyric)),
              ),
            ),
          HighlightableRow(
            title: 'Sdílet',
            icon: Icons.share,
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
            onPressed: _share,
          ),
          HighlightableRow(
            title: 'Otevřít na webu',
            icon: Icons.language,
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
            onPressed: () => launch('$songUrl/${songLyric.id}/'),
          ),
          HighlightableRow(
            title: 'Nahlásit',
            icon: Icons.warning,
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
            onPressed: () => launch('$reportUrl=${songLyric.id}'),
          ),
        ],
      );

  void _share() async => await FlutterShare.share(
        title: songLyric.name,
        linkUrl: '$songUrl/${songLyric.id}/',
        chooserTitle: songLyric.name,
      );
}
