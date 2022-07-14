import 'package:just_audio/just_audio.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zpevnik/models/external.dart';

class ActivePlayerController {
  final External external;

  final YoutubePlayerController? youtubePlayerController;
  final AudioPlayer? audioPlayer;

  const ActivePlayerController(
    this.external, {
    this.youtubePlayerController,
    this.audioPlayer,
  });

  bool get isPlaying => youtubePlayerController?.value.isPlaying ?? audioPlayer?.playing ?? false;

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
