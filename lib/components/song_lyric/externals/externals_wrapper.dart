import 'package:flutter/material.dart';
import 'package:zpevnik/components/song_lyric/externals/externals.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';

const _dragSpeedScale = 0.01;
const _collapseThresholdOffset = 150;

class ExternalsWrapper extends StatefulWidget {
  final SongLyric songLyric;
  final ValueNotifier<bool> showingExternals;

  final Widget child;

  const ExternalsWrapper({
    super.key,
    required this.songLyric,
    required this.showingExternals,
    required this.child,
  });

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
        ValueListenableBuilder(
          valueListenable: widget.showingExternals,
          builder: (_, isShowing, child) => IgnorePointer(
            ignoring: !isShowing,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => widget.showingExternals.value = false,
              child: AnimatedContainer(
                duration: kDefaultAnimationDuration,
                color: isShowing ? Theme.of(context).disabledColor : Colors.transparent,
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: widget.showingExternals,
          builder: (_, isShowing, child) => AnimatedPositioned(
            duration: kDefaultAnimationDuration,
            bottom: isShowing ? 0 : -MediaQuery.of(context).size.height,
            child: child!,
          ),
          child: StatefulBuilder(
            builder: (_, setState) => Transform.translate(
              offset: Offset(0, _bottomOffset),
              child: GestureDetector(
                onPanUpdate: (details) => setState(() => _updateOffset(details)),
                onPanEnd: (details) => _snapOffset(details, setState),
                child: ExternalsWidget(songLyric: widget.songLyric),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _updateOffset(DragUpdateDetails details) {
    _bottomOffset += details.delta.dy;

    if (_bottomOffset < 0) _bottomOffset = 0;
  }

  void _snapOffset(DragEndDetails details, void Function(void Function()) setState) {
    if (_bottomOffset + _dragSpeedScale * details.velocity.pixelsPerSecond.dy > _collapseThresholdOffset) {
      widget.showingExternals.value = false;
      // reset offset with delay
      Future.delayed(kDefaultAnimationDuration, () => setState(() => _bottomOffset = 0));
    } else {
      setState(() => _bottomOffset = 0);
    }
  }
}
