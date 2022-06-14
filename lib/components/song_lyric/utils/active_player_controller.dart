import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zpevnik/models/external.dart';

class ActivePlayerController {
  final External external;

  final YoutubePlayerController? youtubePlayerController;

  const ActivePlayerController(this.external, this.youtubePlayerController);

  bool get isPlaying => youtubePlayerController?.value.isPlaying ?? false;

  void rewind() {
    if (youtubePlayerController != null) {
      youtubePlayerController!.seekTo(youtubePlayerController!.value.position - const Duration(seconds: 5));
    }
  }

  void play() {
    if (youtubePlayerController != null) {
      youtubePlayerController!.play();
    }
  }

  void pause() {
    if (youtubePlayerController != null) {
      youtubePlayerController!.pause();
    }
  }

  void forward() {
    if (youtubePlayerController != null) {
      youtubePlayerController!.seekTo(youtubePlayerController!.value.position + const Duration(seconds: 5));
    }
  }
}
