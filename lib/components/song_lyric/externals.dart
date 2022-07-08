import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zpevnik/components/song_lyric/utils/active_player_controller.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/components/highlightable.dart';

const _youtubePlayerMaxWidth = 300;

class ExternalsWidget extends StatefulWidget {
  final SongLyric songLyric;

  final double percentage;

  final ValueNotifier<bool> isPlaying;

  const ExternalsWidget({
    Key? key,
    required this.songLyric,
    this.percentage = 0.0,
    required this.isPlaying,
  }) : super(key: key);

  @override
  _ExternalsWidgetState createState() => _ExternalsWidgetState();
}

class _ExternalsWidgetState extends State<ExternalsWidget> {
  late final List<ActivePlayerController> _controllers;

  ActivePlayerController? _activePlayerController;

  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    _prepareYoutubeControllers();
  }

  @override
  void dispose() {
    super.dispose();

    for (var controller in _controllers) {
      controller.youtubePlayerController?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.percentage < 0) return Container();

    final width = MediaQuery.of(context).size.width;

    return Stack(
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
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      child: AlignedGridView.count(
                        crossAxisCount: (width / _youtubePlayerMaxWidth).floor(),
                        crossAxisSpacing: kDefaultPadding,
                        mainAxisSpacing: kDefaultPadding,
                        padding: const EdgeInsets.only(bottom: kDefaultPadding),
                        itemCount: _controllers.length,
                        itemBuilder: (context, index) => _buildSection(context, _controllers[index]),
                        primary: false,
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
    );
  }

  Widget _buildSection(BuildContext context, ActivePlayerController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
              child: const Icon(Icons.fast_rewind),
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            ),
            Highlightable(
              onTap: playerController.isPlaying ? playerController.pause : playerController.play,
              child: Icon(playerController.isPlaying ? Icons.pause : Icons.play_arrow),
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            ),
            Highlightable(
              onTap: playerController.forward,
              child: const Icon(Icons.fast_forward),
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            ),
            const Spacer(),
            Highlightable(
              onTap: _dismiss,
              child: const Icon(Icons.close),
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            )
          ],
        ),
      ),
    );
  }

  void _prepareYoutubeControllers() {
    _controllers = [];

    for (final youtube in widget.songLyric.youtubes) {
      if (youtube.mediaId == null) continue;

      final controller = YoutubePlayerController(
        initialVideoId: youtube.mediaId!,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false, loop: true, showLiveFullscreenButton: false),
      );

      final activePlayerController = ActivePlayerController(youtube, controller);
      _controllers.add(activePlayerController);

      controller.addListener(() {
        if (widget.percentage > 0.2) {
          if (controller.value.isPlaying) {
            _activePlayerController = activePlayerController;
            widget.isPlaying.value = true;
          } else {
            _activePlayerController = null;
            widget.isPlaying.value = false;
          }
        } else if (controller.value.isPlaying != _isPlaying) {
          setState(() => _isPlaying = controller.value.isPlaying);
        }
      });
    }
  }

  void _dismiss() {
    _activePlayerController = null;
    widget.isPlaying.value = false;
  }
}
