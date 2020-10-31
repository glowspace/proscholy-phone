import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Přidat do seznamu', Icons.playlist_add, null),
            _row('Zpěvníky', Icons.import_contacts, null),
            _row('Noty', Icons.insert_drive_file, null),
            _row('Sdílet', Icons.share, share),
            _row('Otevřít na webu', Icons.language,
                () => _open('https://zpevnik.proscholy.cz/pisen/${widget.songLyric.id}/')),
            _row(
                'Nahlásit',
                Icons.warning,
                () => _open(
                    'https://docs.google.com/forms/d/e/1FAIpQLSdTaOCzzlfZmyoCB0I_S2kSPiSZVGwDhDovyxkWB7w2LfH0IA/viewform?entry.2038741493=${widget.songLyric.id}')),
          ],
        ),
      ),
      _animation);

  Widget _collapseable(BuildContext context, Widget child, Animation<double> animation) => SizeTransition(
        sizeFactor: animation,
        axis: Axis.vertical,
        child: child,
      );

  Widget _row(String title, IconData icon, Function() onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 4),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: kDefaultPadding / 2),
                child: Icon(icon),
              ),
              Text(title),
            ],
          ),
        ),
      );

  void _open(String url) async => await launch(url);

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
