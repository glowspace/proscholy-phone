import 'package:flutter/material.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/components/song_lyric/utils/active_player_controller.dart';
import 'package:proscholy_common/constants.dart';

class CollapsedPlayer extends StatelessWidget {
  final ActivePlayerController controller;
  final Function()? onDismiss;

  const CollapsedPlayer({super.key, required this.controller, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Row(children: [
        SizedBox(
          width: constraints.maxWidth / 3,
          child: Text(controller.external.name, overflow: TextOverflow.fade),
        ),
        HighlightableWidget(
          onTap: controller.rewind,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          icon: const Icon(Icons.fast_rewind),
        ),
        ValueListenableBuilder(
          valueListenable: controller.isPlaying,
          builder: (_, isPlaying, __) => HighlightableWidget(
            onTap: isPlaying ? controller.pause : controller.play,
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          ),
        ),
        HighlightableWidget(
          onTap: controller.forward,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          icon: const Icon(Icons.fast_forward),
        ),
        const Spacer(),
        HighlightableWidget(
          onTap: onDismiss,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          icon: const Icon(Icons.close),
        )
      ]),
    );
  }
}
