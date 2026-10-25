import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:proscholy_common/components/song_lyric/utils/active_player_controller.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/external.dart';
import 'package:proscholy_common/utils/extensions.dart';

class YoutubePlayerWrapper extends StatefulWidget {
  final External external;

  const YoutubePlayerWrapper({super.key, required this.external});

  @override
  State<YoutubePlayerWrapper> createState() => _YoutubePlayerWrapperState();
}

class _YoutubePlayerWrapperState extends State<YoutubePlayerWrapper> {
  late final _controller = YoutubePlayerController(
    initialVideoId: widget.external.mediaId!,
    flags: const YoutubePlayerFlags(autoPlay: false, mute: false, loop: true, showLiveFullscreenButton: false),
  );

  @override
  void initState() {
    super.initState();

    final activePlayerController = ActivePlayerController(widget.external, youtubePlayerController: _controller);

    _controller.addListener(() {
      if (_controller.value.isPlaying) {
        context.providers.read(activePlayerProvider.notifier).changePlayer(activePlayerController);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(kDefaultRadius)),
      child: YoutubePlayer(controller: _controller),
    );
  }
}
