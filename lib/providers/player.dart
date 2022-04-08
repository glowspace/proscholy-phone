import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zpevnik/models/external.dart';

class ActivePlayerController {
  final External external;

  final YoutubePlayerController? youtubePlayerController;

  const ActivePlayerController(this.external, this.youtubePlayerController);
}

class PlayerProvider extends ChangeNotifier {
  final MiniplayerController miniplayerController;
  final ValueNotifier<double> miniplayerExpandProgress;

  PlayerProvider(this.miniplayerController, this.miniplayerExpandProgress);

  Widget Function(double, double)? _builder;

  Widget Function(double, double) get builder => _builder ?? (_, __) => Container();

  set builder(Widget Function(double, double)? builder) {
    _builder = builder;

    notifyListeners();
  }

  ActivePlayerController? _activePlayerController;

  ActivePlayerController? get activePlayerController => _activePlayerController;

  set activePlayerController(ActivePlayerController? newController) {
    if (newController == _activePlayerController) return;

    _activePlayerController = newController;
    notifyListeners();
  }

  bool get hasActivePlayer => _activePlayerController != null;
  bool get isPlaying => activePlayerController?.youtubePlayerController?.value.isPlaying ?? false;
}
