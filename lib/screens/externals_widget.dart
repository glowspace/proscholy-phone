import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/theme.dart';

final RegExp _nameRE = RegExp(r'youtube \([^|]+\|\s?(.+)\)');

class ExternalsWidget extends StatefulWidget {
  final SongLyric songLyric;

  const ExternalsWidget({Key key, this.songLyric}) : super(key: key);

  @override
  _ExternalsWidgetState createState() => _ExternalsWidgetState();
}

class _ExternalsWidgetState extends State<ExternalsWidget> {
  List<YoutubePlayerController> _controllers;

  @override
  initState() {
    super.initState();
    _controllers = widget.songLyric.youtubes
        .map((youtube) => YoutubePlayerController(
              initialVideoId: youtube.mediaId,
              flags: YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(kDefaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              _controllers.length,
              (index) => _section(
                  context, _nameRE.firstMatch(widget.songLyric.youtubes[index].name).group(1), _controllers[index]),
            ),
          ),
        ),
      );

  Widget _section(BuildContext context, String name, YoutubePlayerController controller) => Column(
        children: [
          YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: false,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2, horizontal: kDefaultPadding / 2),
            color: AppTheme.shared.selectedColor(context),
            child: Text(name),
          ),
        ],
      );
}
