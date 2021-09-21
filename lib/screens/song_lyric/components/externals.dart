import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/screens/components/bottom_form_sheet.dart';
import 'package:zpevnik/theme.dart';

class ExternalsWidget extends StatefulWidget {
  final List<External> externals;

  const ExternalsWidget({Key? key, this.externals = const []}) : super(key: key);

  @override
  _ExternalsWidgetState createState() => _ExternalsWidgetState();
}

class _ExternalsWidgetState extends State<ExternalsWidget> {
  late List<YoutubePlayerController> _controllers;

  @override
  void initState() {
    super.initState();

    _controllers = widget.externals
        .map((youtube) => YoutubePlayerController(
              initialVideoId: youtube.mediaId,
              flags: YoutubePlayerFlags(autoPlay: false, mute: false),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BottomFormSheet(
      title: 'Nahrávky',
      items: List.generate(
        _controllers.length,
        (index) => _section(context, widget.externals[index].name, _controllers[index]),
      ),
    );
  }

  Widget _section(BuildContext context, String name, YoutubePlayerController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // fixme: blurres navbar on iOS
        YoutubePlayer(controller: controller),
        Container(
          padding: EdgeInsets.all(kDefaultPadding),
          color: AppTheme.of(context).fillColor,
          child: Text(name),
        ),
      ],
    );
  }
}
