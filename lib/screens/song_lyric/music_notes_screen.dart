import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/providers/full_screen_provider.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

final _colorRE = RegExp(r'Color\(0xff(.+)\)');

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

  String _preparedLilyPond;

  @override
  void initState() {
    super.initState();

    _scaleFactor = 1;
    _offset = Offset.zero;
  }

  @override
  Widget iOSWidget(BuildContext context) => Consumer<FullScreenProvider>(
        builder: (context, provider, _) => WillPopScope(
          onWillPop: provider.fullScreen ? () async => !Navigator.of(context).userGestureInProgress : null,
          child: CupertinoPageScaffold(
            navigationBar: provider.fullScreen ? null : CupertinoNavigationBar(middle: Text('Noty')),
            child: SafeArea(child: _body(context)),
          ),
        ),
      );

  @override
  Widget androidWidget(BuildContext context) => Consumer<FullScreenProvider>(
        builder: (context, provider, _) => Scaffold(
          appBar: provider.fullScreen
              ? null
              : AppBar(
                  title: Text('Noty'),
                  shadowColor: AppTheme.of(context).appBarDividerColor,
                  brightness: AppTheme.of(context).brightness,
                ),
          body: SafeArea(child: _body(context)),
        ),
      );

  Widget _body(BuildContext context) {
    final fullScreenProvider = Provider.of<FullScreenProvider>(context, listen: false);

    _preparedLilyPond ??= widget.songLyric.lilypond.replaceAll('currentColor',
        AppTheme.of(context).textColor.toString().replaceAllMapped(_colorRE, (match) => '#${match.group(1)}'));

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
      onTap: fullScreenProvider.toggle,
      child: Center(
        child: Transform.translate(
          offset: _offset,
          child: Transform.scale(
            scale: _scaleFactor,
            child: SvgPicture.string(_preparedLilyPond, height: MediaQuery.of(context).size.height),
          ),
        ),
      ),
    );
  }
}
