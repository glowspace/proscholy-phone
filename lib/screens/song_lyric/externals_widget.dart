import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/theme.dart';

final RegExp _nameRE = RegExp(r'youtube \(([^|]+\|\s?)?(.+)\)');

// fixme: Youtube player is not supported on cupertino widgets (maybe write custom player)
class ExternalsWidget extends StatefulWidget {
  final SongLyric songLyric;

  const ExternalsWidget({Key key, this.songLyric}) : super(key: key);

  @override
  _ExternalsWidgetState createState() => _ExternalsWidgetState();
}

class _ExternalsWidgetState extends State<ExternalsWidget> {
  List<VideoPlayerController> _controllers;

  @override
  initState() {
    super.initState();
    _controllers = widget.songLyric.youtubes
        .map((youtube) => VideoPlayerController.network('https://www.youtube.com/watch?v=${youtube.mediaId}')
          ..addListener(() => setState(() {}))
          ..initialize())
        .toList();
  }

  @override
  Widget build(BuildContext context) => Container(
        color: AppThemeNew.of(context).fillColor,
        padding: EdgeInsets.all(kDefaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              _controllers.length,
              (index) => _section(
                  context, _nameRE.firstMatch(widget.songLyric.youtubes[index].name).group(2), _controllers[index]),
            ),
          ),
        ),
      );

  Widget _section(BuildContext context, String name, VideoPlayerController controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: VideoPlayer(controller),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2, horizontal: kDefaultPadding / 2),
            color: AppTheme.shared.selectedColor(context),
            child: Text(name),
          ),
        ],
      );

  @override
  void dispose() {
    for (final controller in _controllers) controller.dispose();

    super.dispose();
  }
}
