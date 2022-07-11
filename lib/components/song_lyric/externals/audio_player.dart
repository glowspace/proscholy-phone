import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/song_lyric/externals/seek_bar.dart';
import 'package:zpevnik/components/song_lyric/utils/active_player_controller.dart';
import 'package:zpevnik/constants.dart';

class AudioPlayerWidget extends StatelessWidget {
  final ActivePlayerController controller;

  const AudioPlayerWidget({Key? key, required this.controller}) : super(key: key);

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
          child: const Icon(Icons.fast_rewind),
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
        ),
        StreamBuilder<PlayerState>(
          stream: controller.audioPlayer!.playerStateStream,
          builder: (_, __) => Highlightable(
            onTap: controller.isPlaying ? controller.pause : controller.play,
            child: Icon(controller.isPlaying ? Icons.pause : Icons.play_arrow),
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          ),
        ),
        Highlightable(
          onTap: controller.forward,
          child: const Icon(Icons.fast_forward),
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
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
