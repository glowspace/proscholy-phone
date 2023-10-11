import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/song_lyric/externals/seek_bar.dart';
import 'package:zpevnik/components/song_lyric/utils/active_player_controller.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/external.dart';

class AudioPlayerWrapper extends ConsumerStatefulWidget {
  final External external;

  const AudioPlayerWrapper({super.key, required this.external});

  @override
  ConsumerState<AudioPlayerWrapper> createState() => _AudioPlayerWrapperState();
}

class _AudioPlayerWrapperState extends ConsumerState<AudioPlayerWrapper> {
  late final _controller = AudioPlayer()..setUrl(widget.external.url!, preload: false);

  @override
  void initState() {
    super.initState();

    final activePlayerController = ActivePlayerController(widget.external, audioPlayer: _controller);

    _controller.playingStream.listen((isPlaying) {
      if (isPlaying) ref.read(activePlayerProvider.notifier).changePlayer(activePlayerController);
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
        Highlightable(
          onTap: () => _controller.seek(_controller.position - const Duration(seconds: 5)),
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          icon: const Icon(Icons.fast_rewind),
        ),
        StreamBuilder(
          stream: _controller.playingStream,
          builder: (_, isPlaying) => isPlaying.hasData
              ? Highlightable(
                  onTap: isPlaying.data! ? _controller.pause : _controller.play,
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                  icon: Icon(isPlaying.data! ? Icons.pause : Icons.play_arrow),
                )
              : const CircularProgressIndicator.adaptive(),
        ),
        Highlightable(
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
