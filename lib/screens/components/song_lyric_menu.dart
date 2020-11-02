import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/screens/components/higlightable_row.dart';
import 'package:zpevnik/screens/music_notes_screen.dart';
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
  Widget build(BuildContext context) => _collapseable(
      context,
      Container(
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
              HighlightableRow(title: 'Přidat do seznamu', icon: Icons.playlist_add, onPressed: null),
              // HighlightableRow('Zpěvníky', Icons.import_contacts, null),
              if (widget.songLyric.lilypond != null)
                HighlightableRow(
                  title: 'Noty',
                  icon: Icons.insert_drive_file,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MusicNotesScreen(songLyric: widget.songLyric),
                    ),
                  ),
                ),
              HighlightableRow(title: 'Sdílet', icon: Icons.share, onPressed: share),
              HighlightableRow(
                  title: 'Otevřít na webu',
                  icon: Icons.language,
                  onPressed: () => launch('https://zpevnik.proscholy.cz/pisen/${widget.songLyric.id}/')),
              HighlightableRow(
                  title: 'Nahlásit',
                  icon: Icons.warning,
                  onPressed: () => launch(
                      'https://docs.google.com/forms/d/e/1FAIpQLSdTaOCzzlfZmyoCB0I_S2kSPiSZVGwDhDovyxkWB7w2LfH0IA/viewform?entry.2038741493=${widget.songLyric.id}')),
            ],
          ),
        ),
      ),
      _animation);

  Widget _collapseable(BuildContext context, Widget child, Animation<double> animation) => SizeTransition(
        sizeFactor: animation,
        axis: Axis.vertical,
        child: child,
      );

  void share() async => await FlutterShare.share(
      title: widget.songLyric.name,
      linkUrl: 'https://zpevnik.proscholy.cz/pisen/${widget.songLyric.id}/',
      chooserTitle: widget.songLyric.name);

  void _update() => widget.showing.value ? _controller.forward() : _controller.reverse();

  @override
  void dispose() {
    widget.showing.removeListener(_update);
    _controller.dispose();

    super.dispose();
  }
}
