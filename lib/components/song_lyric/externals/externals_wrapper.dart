import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/song_lyric/externals/externals.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/display_screen_status.dart';

const _dragSpeedScale = 0.01;
const _collapseThresholdOffset = 150;

class ExternalsWrapper extends StatefulWidget {
  final SongLyric? songLyric;

  final Widget child;

  const ExternalsWrapper({super.key, this.songLyric, required this.child});

  @override
  State<ExternalsWrapper> createState() => _ExternalsWrapperState();
}

class _ExternalsWrapperState extends State<ExternalsWrapper> {
  double _bottomOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Consumer(
          builder: (_, ref, child) => IgnorePointer(
            ignoring: !ref.watch(displayScreenStatusProvider.select((status) => status.showingExternals)),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: ref.read(displayScreenStatusProvider.notifier).hideExternals,
              child: AnimatedContainer(
                duration: kDefaultAnimationDuration,
                color: ref.watch(displayScreenStatusProvider.select((status) => status.showingExternals))
                    ? Colors.black.withAlpha(0x80)
                    : Colors.transparent,
              ),
            ),
          ),
        ),
        if (widget.songLyric != null)
          Consumer(
            builder: (_, ref, child) => AnimatedPositioned(
              duration: kDefaultAnimationDuration,
              bottom: ref.watch(displayScreenStatusProvider.select((status) => status.showingExternals))
                  ? 0
                  : -MediaQuery.sizeOf(context).height,
              child: StatefulBuilder(
                builder: (_, setState) => Transform.translate(
                  offset: Offset(0, _bottomOffset),
                  child: GestureDetector(
                      onPanUpdate: (details) => setState(() => _updateOffset(details)),
                      onPanEnd: (details) => _snapOffset(details, setState, ref),
                      child: child!),
                ),
              ),
            ),
            child: ExternalsWidget(songLyric: widget.songLyric!),
          )
      ],
    );
  }

  void _updateOffset(DragUpdateDetails details) {
    _bottomOffset += details.delta.dy;

    if (_bottomOffset < 0) _bottomOffset = 0;
  }

  void _snapOffset(DragEndDetails details, void Function(void Function()) setState, WidgetRef ref) {
    if (_bottomOffset + _dragSpeedScale * details.velocity.pixelsPerSecond.dy > _collapseThresholdOffset) {
      ref.read(displayScreenStatusProvider.notifier).hideExternals();
      // reset offset with delay
      Future.delayed(kDefaultAnimationDuration, () => setState(() => _bottomOffset = 0));
    } else {
      setState(() => _bottomOffset = 0);
    }
  }
}
