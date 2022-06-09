import 'dart:math';

import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/player.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/theme.dart';

class ExternalsWidget extends StatefulWidget {
  final double percentage;
  final SongLyric songLyric;

  const ExternalsWidget({Key? key, required this.songLyric, this.percentage = 0.0}) : super(key: key);

  @override
  _ExternalsWidgetState createState() => _ExternalsWidgetState();
}

class _ExternalsWidgetState extends State<ExternalsWidget> {
  final List<ActivePlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();

    _prepareYoutubeControllers();
  }

  @override
  void didUpdateWidget(covariant ExternalsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.songLyric.id != oldWidget.songLyric.id) _prepareYoutubeControllers();
  }

  void _prepareYoutubeControllers() {
    final playerProvider = context.read<PlayerProvider>();

    _controllers.clear();

    for (final youtube in widget.songLyric.youtubes) {
      final controller = YoutubePlayerController(
        initialVideoId: youtube.mediaId,
        flags: YoutubePlayerFlags(autoPlay: false, mute: false),
      );

      final activePlayerController = ActivePlayerController(youtube, controller);
      _controllers.add(activePlayerController);

      controller.addListener(() {
        if (widget.percentage > 0.5) {
          if (controller.value.isPlaying)
            playerProvider.activePlayerController = activePlayerController;
          else
            playerProvider.activePlayerController = null;
        } else
          setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();

    final playerSections = _controllers.map((controller) => _buildSection(context, controller)).toList();

    if (playerProvider.hasActivePlayer &&
        playerProvider.activePlayerController!.external.songLyricId != widget.songLyric.id)
      playerSections.add(_buildSection(context, playerProvider.activePlayerController!));

    return Container(
      color: AppTheme.of(context).fillColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            // opacity can't be zero, otherwise player will be disposed and will stop plaing
            opacity: min(1.0, widget.percentage + 0.01),
            child: Transform.scale(
              alignment: Alignment.topLeft,
              scale: widget.percentage,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      margin: EdgeInsets.only(bottom: kDefaultPadding),
                      child: Text('Nahrávky', style: AppTheme.of(context).titleTextStyle),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: playerSections,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (playerProvider.hasActivePlayer) _buildCollapsedPlayer()
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, ActivePlayerController controller) {
    return Column(
      key: Key(controller.external.name),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        YoutubePlayer(key: Key(controller.external.name), controller: controller.youtubePlayerController!),
        Container(
          padding: EdgeInsets.all(kDefaultPadding),
          color: AppTheme.of(context).fillColor,
          child: Text(controller.external.name),
        ),
      ],
    );
  }

  Widget _buildCollapsedPlayer() {
    final playerProvider = context.watch<PlayerProvider>();
    final playerController = playerProvider.activePlayerController!;
    final youtubePlayerController = playerController.youtubePlayerController;

    return Opacity(
      opacity: 1.0 - widget.percentage,
      child: Transform.scale(
        alignment: Alignment.bottomCenter,
        scale: 1.0 - widget.percentage,
        child: Container(
          padding: EdgeInsets.all(kDefaultPadding),
          child: Row(
            children: [
              Flexible(child: Text(playerController.external.name)),
              Highlightable(
                child: Icon(Icons.fast_rewind),
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                onTap: youtubePlayerController == null
                    ? null
                    : () =>
                        youtubePlayerController.seekTo(youtubePlayerController.value.position - Duration(seconds: 5)),
              ),
              Highlightable(
                child: Icon(playerProvider.isPlaying ? Icons.pause : Icons.play_arrow),
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                onTap: playerProvider.isPlaying ? youtubePlayerController?.pause : youtubePlayerController?.play,
              ),
              Highlightable(
                child: Icon(Icons.fast_forward),
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                onTap: youtubePlayerController == null
                    ? null
                    : () =>
                        youtubePlayerController.seekTo(youtubePlayerController.value.position + Duration(seconds: 5)),
              ),
              Spacer(),
              Highlightable(
                child: Icon(Icons.close),
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                onTap: () {
                  context.read<PlayerProvider>().miniplayerController.animateToHeight(state: PanelState.DISMISS);
                  youtubePlayerController?.reset();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
