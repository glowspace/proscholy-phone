import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/song_lyric/utils/active_player_controller.dart';
import 'package:zpevnik/constants.dart';

class CollapsedPlayer extends StatelessWidget {
  final ActivePlayerController controller;
  final Function()? onDismiss;

  const CollapsedPlayer({super.key, required this.controller, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding),
      child: Row(children: [
        SizedBox(
          width: width / 3,
          child: Text(controller.external.name, overflow: TextOverflow.fade),
        ),
        Highlightable(
          onTap: controller.rewind,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          icon: const Icon(Icons.fast_rewind),
        ),
        ValueListenableBuilder(
          valueListenable: controller.isPlaying,
          builder: (_, isPlaying, __) => Highlightable(
            onTap: isPlaying ? controller.pause : controller.play,
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          ),
        ),
        Highlightable(
          onTap: controller.forward,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          icon: const Icon(Icons.fast_forward),
        ),
        const Spacer(),
        Highlightable(
          onTap: onDismiss,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          icon: const Icon(Icons.close),
        )
      ]),
    );
  }
}
