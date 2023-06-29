import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:just_audio/just_audio.dart' hide PlayerState;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zpevnik/components/custom/future_builder.dart';
import 'package:zpevnik/components/song_lyric/externals/audio_player.dart';
import 'package:zpevnik/components/song_lyric/utils/active_player_controller.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/components/highlightable.dart';

const _youtubePlayerMaxWidth = 250;
const _noInternetMessage =
    'Nahrávky jsou dostupné pouze přes internet. Zkontrolujte prosím připojení k${unbreakableSpace}internetu.';

class ExternalsWidget extends StatefulWidget {
  final SongLyric songLyric;

  final double percentage;

  final double width;

  final ValueNotifier<bool> isPlaying;

  const ExternalsWidget({
    super.key,
    required this.songLyric,
    this.percentage = 0.0,
    required this.width,
    required this.isPlaying,
  });

  @override
  State<ExternalsWidget> createState() => _ExternalsWidgetState();
}

class _ExternalsWidgetState extends State<ExternalsWidget> {
  final List<ActivePlayerController> _controllers = [];

  ActivePlayerController? _activePlayerController;

  bool _isPlaying = false;

  late final Future<void> _initFuture;

  @override
  void initState() {
    super.initState();

    _initFuture = _checkInternetAndPrepare();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.percentage < 0) return Container();

    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            // opacity can't be zero, otherwise player will be disposed and will stop plaing
            opacity: min(1, widget.percentage + 0.01),
            child: Transform.translate(
              // because opacity can't be zero, translate it out of screen, so it won't be visible
              offset: Offset(0, widget.percentage == 0 ? 100 : 0),
              child: Container(
                padding: const EdgeInsets.only(top: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      margin: const EdgeInsets.only(bottom: kDefaultPadding),
                      child: Text('Nahrávky', style: Theme.of(context).textTheme.titleLarge),
                    ),
                    CustomFutureBuilder<void>(
                      future: _initFuture,
                      errorBuilder: (_, __) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        child: const Text(_noInternetMessage, textAlign: TextAlign.center),
                      ),
                      builder: (_, __) => Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                          child: AlignedGridView.count(
                            crossAxisCount: (widget.width / _youtubePlayerMaxWidth).floor(),
                            crossAxisSpacing: kDefaultPadding,
                            mainAxisSpacing: kDefaultPadding,
                            padding: const EdgeInsets.only(bottom: kDefaultPadding),
                            itemCount: _controllers.length,
                            itemBuilder: (context, index) => _buildSection(context, _controllers[index]),
                            primary: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_activePlayerController != null) _buildCollapsedPlayer(context),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, ActivePlayerController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (controller.youtubePlayerController != null)
          YoutubePlayer(
            controller: controller.youtubePlayerController!,
            bottomActions: [
              const SizedBox(width: 14.0),
              CurrentPosition(),
              const SizedBox(width: 8.0),
              ProgressBar(isExpanded: true),
              RemainingDuration(),
              const SizedBox(width: 14.0),
            ],
          ),
        Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Text(controller.external.name),
        ),
        if (controller.audioPlayer != null) AudioPlayerWidget(controller: controller),
      ],
    );
  }

  Widget _buildCollapsedPlayer(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final playerController = _activePlayerController!;

    return Opacity(
      opacity: max(0, 1 - widget.percentage),
      child: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Row(
          children: [
            SizedBox(
              width: width / 3,
              child: Text(playerController.external.name, overflow: TextOverflow.fade),
            ),
            Highlightable(
              onTap: playerController.rewind,
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              icon: const Icon(Icons.fast_rewind),
            ),
            Highlightable(
              onTap: playerController.isPlaying ? playerController.pause : playerController.play,
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              icon: Icon(playerController.isPlaying ? Icons.pause : Icons.play_arrow),
            ),
            Highlightable(
              onTap: playerController.forward,
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              icon: const Icon(Icons.fast_forward),
            ),
            const Spacer(),
            Highlightable(
              onTap: _dismiss,
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              icon: const Icon(Icons.close),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _checkInternetAndPrepare() async {
    await InternetAddress.lookup("youtube.com");

    _prepareYoutubeControllers();
    _prepareMp3Controllers();
  }

  void _prepareYoutubeControllers() {
    for (final youtube in widget.songLyric.youtubes) {
      if (youtube.mediaId == null) continue;

      final controller = YoutubePlayerController(
        initialVideoId: youtube.mediaId!,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false, loop: true, showLiveFullscreenButton: false),
      );

      final activePlayerController = ActivePlayerController(youtube, youtubePlayerController: controller);
      _controllers.add(activePlayerController);

      controller.addListener(() => _handlePlayingChange(activePlayerController));
    }
  }

  void _prepareMp3Controllers() {
    for (final mp3 in widget.songLyric.mp3s) {
      if (mp3.url == null) continue;

      final player = AudioPlayer();
      player.setUrl(mp3.url!);

      final activePlayerController = ActivePlayerController(mp3, audioPlayer: player);
      _controllers.add(activePlayerController);

      player.playingStream.listen((isPlaying) => _handlePlayingChange(activePlayerController));
    }
  }

  void _handlePlayingChange(ActivePlayerController activePlayerController) {
    if (activePlayerController.isPlaying == _isPlaying && _activePlayerController == activePlayerController) return;

    if (!activePlayerController.isPlaying && _activePlayerController != activePlayerController) return;

    if (widget.percentage > 0.2) {
      if (activePlayerController.isPlaying) {
        _activePlayerController?.pause();

        _activePlayerController = activePlayerController;
        widget.isPlaying.value = true;
      } else {
        _activePlayerController = null;
        widget.isPlaying.value = false;
      }

      _isPlaying = activePlayerController.isPlaying;
    } else {
      setState(() => _isPlaying = activePlayerController.isPlaying);
    }
  }

  void _dismiss() {
    _activePlayerController?.pause();
    _activePlayerController = null;
    widget.isPlaying.value = false;
  }
}
