import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

final RegExp _colorRE = RegExp(r'Color\(0xff(.+)\)');

class MusicNotesScreen extends StatefulWidget {
  final SongLyric songLyric;

  const MusicNotesScreen({Key key, this.songLyric}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MusicNotesScreenState();
}

class _MusicNotesScreenState extends State<MusicNotesScreen> with PlatformStateMixin {
  double _baseScaleFactor;
  double _scaleFactor;

  Offset _baseOffset;
  Offset _scaleStart;
  Offset _offset;

  @override
  void initState() {
    super.initState();

    _scaleFactor = 1;
    _offset = Offset.zero;
  }

  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Noty'),
        ),
        child: SafeArea(child: _body(context)),
      );

  @override
  Widget androidWidget(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Noty'),
          shadowColor: AppTheme.shared.appBarDividerColor(context),
        ),
        body: SafeArea(child: _body(context)),
      );

  Widget _body(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onScaleStart: (details) {
        _baseScaleFactor = _scaleFactor;
        _scaleStart = details.focalPoint;
        _baseOffset = _offset;
      },
      onScaleUpdate: (details) => setState(() {
        _offset = _baseOffset.translate(details.focalPoint.dx - _scaleStart.dx, details.focalPoint.dy - _scaleStart.dy);
        _scaleFactor = _baseScaleFactor * details.scale;
      }),
      child: Center(
        child: Transform.translate(
          offset: _offset,
          child: Transform.scale(
            scale: _scaleFactor,
            child: SvgPicture.string(
                widget.songLyric.lilypond.replaceAll(
                    'currentColor',
                    AppTheme.shared
                        .textColor(context)
                        .toString()
                        .replaceAllMapped(_colorRE, (match) => '#${match.group(1)}')),
                height: size.height),
          ),
        ),
      ),
    );
  }
}
