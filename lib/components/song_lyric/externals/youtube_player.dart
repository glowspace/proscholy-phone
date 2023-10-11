import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zpevnik/components/song_lyric/utils/active_player_controller.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/external.dart';

class YoutubePlayerWrapper extends ConsumerStatefulWidget {
  final External external;

  const YoutubePlayerWrapper({super.key, required this.external});

  @override
  ConsumerState<YoutubePlayerWrapper> createState() => _YoutubePlayerWrapperState();
}

class _YoutubePlayerWrapperState extends ConsumerState<YoutubePlayerWrapper> {
  late final _controller = YoutubePlayerController(
    initialVideoId: widget.external.mediaId!,
    flags: const YoutubePlayerFlags(autoPlay: false, mute: false, loop: true, showLiveFullscreenButton: false),
  );

  @override
  void initState() {
    super.initState();

    final activePlayerController = ActivePlayerController(widget.external, youtubePlayerController: _controller);

    _controller.addListener(() {
      if (_controller.value.isPlaying) ref.read(activePlayerProvider.notifier).changePlayer(activePlayerController);
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
