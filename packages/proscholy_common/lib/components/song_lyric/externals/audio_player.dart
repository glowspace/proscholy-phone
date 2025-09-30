import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/components/song_lyric/externals/seek_bar.dart';
import 'package:proscholy_common/components/song_lyric/utils/active_player_controller.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/external.dart';
import 'package:proscholy_common/utils/extensions.dart';

class AudioPlayerWrapper extends StatefulWidget {
  final External external;

  const AudioPlayerWrapper({super.key, required this.external});

  @override
  State<AudioPlayerWrapper> createState() => _AudioPlayerWrapperState();
}

class _AudioPlayerWrapperState extends State<AudioPlayerWrapper> {
  late final _controller = AudioPlayer()..setUrl(widget.external.url!, preload: false);

  @override
  void initState() {
    super.initState();

    final activePlayerController = ActivePlayerController(widget.external, audioPlayer: _controller);

    _controller.playingStream.listen((isPlaying) {
      final context = this.context;

      if (isPlaying && context.mounted) {
        context.providers.read(activePlayerProvider.notifier).changePlayer(activePlayerController);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Stream<PositionData> get _positionDataStream => Rx.combineLatest2<Duration, Duration?, PositionData>(
      _controller.positionStream,
      _controller.durationStream,
      (position, duration) => PositionData(position, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HighlightableWidget(
          onTap: () => _controller.seek(_controller.position - const Duration(seconds: 5)),
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          icon: const Icon(Icons.fast_rewind),
        ),
        StreamBuilder(
          stream: _controller.playingStream,
          builder: (_, isPlaying) => isPlaying.hasData
              ? HighlightableWidget(
                  onTap: isPlaying.data! ? _controller.pause : _controller.play,
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                  icon: Icon(isPlaying.data! ? Icons.pause : Icons.play_arrow),
                )
              : const CircularProgressIndicator.adaptive(),
        ),
        HighlightableWidget(
          onTap: () => _controller.seek(_controller.position + const Duration(seconds: 5)),
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          icon: const Icon(Icons.fast_forward),
        ),
        Expanded(
          child: StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                duration: positionData?.duration ?? Duration.zero,
                position: positionData?.position ?? Duration.zero,
                onChangeEnd: _controller.seek,
              );
            },
          ),
        ),
      ],
    );
  }
}
