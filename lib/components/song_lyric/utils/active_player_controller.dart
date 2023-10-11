import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zpevnik/models/external.dart';

part 'active_player_controller.g.dart';

@riverpod
class ActivePlayer extends _$ActivePlayer {
  @override
  ActivePlayerController? build() => null;

  // pause current active player and change to new one
  void changePlayer(ActivePlayerController controller) {
    // do it only if we really change external that is playing
    if (controller.external != state?.external) {
      state?.pause();
      state = controller;

      ref.onDispose(controller.dispose);
    }
  }

  void dismiss() {
    state?.pause();
    state = null;
  }
}

class ActivePlayerController {
  final External external;

  final YoutubePlayerController? youtubePlayerController;
  final AudioPlayer? audioPlayer;

  ActivePlayerController(this.external, {this.youtubePlayerController, this.audioPlayer}) {
    youtubePlayerController?.addListener(() => _isPlaying.value = youtubePlayerController!.value.isPlaying);
    audioPlayer?.playingStream.listen((isPlaying) => _isPlaying.value = isPlaying);
  }

  final _isPlaying = ValueNotifier(false);

  ValueNotifier<bool> get isPlaying => _isPlaying;

  void rewind() {
    youtubePlayerController?.seekTo(youtubePlayerController!.value.position - const Duration(seconds: 5));
    audioPlayer?.seek(audioPlayer == null ? null : audioPlayer!.position - const Duration(seconds: 5));
  }

  void play() {
    youtubePlayerController?.play();
    audioPlayer?.play();
  }

  void pause() {
    youtubePlayerController?.pause();
    audioPlayer?.pause();
  }

  void forward() {
    youtubePlayerController?.seekTo(youtubePlayerController!.value.position + const Duration(seconds: 5));
    audioPlayer?.seek(audioPlayer == null ? null : audioPlayer!.position + const Duration(seconds: 5));
  }

  void dispose() {
    youtubePlayerController?.dispose();
    audioPlayer?.dispose();
  }
}
