import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/bottom_sheets.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/screens/components/higlightable_row.dart';
import 'package:zpevnik/screens/song_lyric/music_notes_screen.dart';
import 'package:zpevnik/theme.dart';

class SongLyricMenu extends StatefulWidget {
  final SongLyric songLyric;
  final ValueNotifier<bool> showing;

  const SongLyricMenu({Key key, this.songLyric, this.showing}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongLyricMenuState();
}

class _SongLyricMenuState extends State<SongLyricMenu> with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: kDefaultAnimationTime), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)..addListener(() => setState(() {}));

    widget.showing.addListener(_update);
  }

  @override
  Widget build(BuildContext context) => SizeTransition(
        sizeFactor: _animation,
        axis: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
                left: BorderSide(color: AppTheme.shared.borderColor(context)),
                bottom: BorderSide(color: AppTheme.shared.borderColor(context))),
          ),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HighlightableRow(
                  title: 'Přidat do seznamu',
                  icon: Icons.playlist_add,
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                  onPressed: () => showPlaylists(context, []),
                ),
                // HighlightableRow('Zpěvníky', Icons.import_contacts, null),
                if (widget.songLyric.lilypond != null)
                  HighlightableRow(
                    title: 'Noty',
                    icon: Icons.insert_drive_file,
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MusicNotesScreen(songLyric: widget.songLyric)),
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
                  onPressed: () => launch('$songUrl/${widget.songLyric.id}/'),
                ),
                HighlightableRow(
                  title: 'Nahlásit',
                  icon: Icons.warning,
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                  onPressed: () => launch('$reportUrl=${widget.songLyric.id}'),
                ),
              ],
            ),
          ),
        ),
      );

  void _share() async => await FlutterShare.share(
        title: widget.songLyric.name,
        linkUrl: '$songUrl/${widget.songLyric.id}/',
        chooserTitle: widget.songLyric.name,
      );

  void _update() => widget.showing.value ? _controller.forward() : _controller.reverse();

  @override
  void dispose() {
    widget.showing.removeListener(_update);
    _controller.dispose();

    super.dispose();
  }
}
