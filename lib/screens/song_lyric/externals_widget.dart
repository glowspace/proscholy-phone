import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/screens/components/bottom_form_sheet.dart';
import 'package:zpevnik/theme.dart';

final RegExp _nameRE = RegExp(r'youtube \(([^|]+\|\s?)?(.+)\)');

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
              flags: YoutubePlayerFlags(autoPlay: false, mute: false),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) => BottomFormSheet(
        title: 'Nahrávky',
        items: List.generate(
          _controllers.length,
          (index) => _section(
            context,
            _nameRE.firstMatch(widget.songLyric.youtubes[index].name).group(2),
            _controllers[index],
          ),
        ),
      );

  Widget _section(BuildContext context, String name, YoutubePlayerController controller) => Container(
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // fixme: blurres navbar on iOS
            YoutubePlayer(controller: controller),
            Container(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2, horizontal: kDefaultPadding / 2),
              color: AppTheme.of(context).highlightColor,
              child: Text(name),
            ),
          ],
        ),
      );
}
