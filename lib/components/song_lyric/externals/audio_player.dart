import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/song_lyric/externals/seek_bar.dart';
import 'package:zpevnik/components/song_lyric/utils/active_player_controller.dart';
import 'package:zpevnik/constants.dart';

class AudioPlayerWidget extends StatelessWidget {
  final ActivePlayerController controller;

  const AudioPlayerWidget({super.key, required this.controller});

  Stream<PositionData> get _positionDataStream => Rx.combineLatest2<Duration, Duration?, PositionData>(
      controller.audioPlayer!.positionStream,
      controller.audioPlayer!.durationStream,
      (position, duration) => PositionData(position, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Highlightable(
          onTap: controller.rewind,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          icon: const Icon(Icons.fast_rewind),
        ),
        StreamBuilder<PlayerState>(
          stream: controller.audioPlayer!.playerStateStream,
          builder: (_, __) => Highlightable(
            onTap: controller.isPlaying ? controller.pause : controller.play,
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
            icon: Icon(controller.isPlaying ? Icons.pause : Icons.play_arrow),
          ),
        ),
        Highlightable(
          onTap: controller.forward,
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
                onChangeEnd: controller.audioPlayer!.seek,
              );
            },
          ),
        ),
      ],
    );
  }
}
