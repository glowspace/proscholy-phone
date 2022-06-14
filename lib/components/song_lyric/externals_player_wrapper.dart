import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zpevnik/components/song_lyric/externals.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';

const _dragSpeedScale = 0.01;

class ExternalsPlayerWrapper extends StatefulWidget {
  final SongLyric songLyric;
  final ValueNotifier<bool> isShowing;

  final double maxHeight;
  final double minHeight;

  const ExternalsPlayerWrapper({
    Key? key,
    required this.songLyric,
    required this.isShowing,
    this.maxHeight = 0,
    this.minHeight = 0,
  }) : super(key: key);

  @override
  State<ExternalsPlayerWrapper> createState() => _ExternalsPlayerWrapperState();
}

class _ExternalsPlayerWrapperState extends State<ExternalsPlayerWrapper> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  final _height = ValueNotifier(0.0);

  final _isPlaying = ValueNotifier(false);

  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(duration: kDefaultAnimationDuration, vsync: this);
    // _animationController = AnimationController(duration: const Duration(seconds: 5), vsync: this);

    widget.isShowing.addListener(_updateHeight);
    _isPlaying.addListener(_isPlayingChanged);
  }

  @override
  void didUpdateWidget(covariant ExternalsPlayerWrapper oldWidget) {
    if (_height.value == oldWidget.maxHeight && widget.maxHeight != oldWidget.maxHeight) {
      _height.value = widget.maxHeight;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();

    widget.isShowing.removeListener(_updateHeight);
    _isPlaying.removeListener(_isPlayingChanged);

    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: _height,
      builder: (_, height, __) => Stack(
        children: [
          if (height > 0 && !(height == widget.minHeight && _isCollapsed))
            GestureDetector(
              onTap: _collapseOrHide,
              child: Opacity(
                opacity: height / widget.maxHeight,
                child: Container(color: Colors.black.withAlpha(0x80)),
              ),
              behavior: HitTestBehavior.deferToChild,
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: height,
              child: GestureDetector(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(kDefaultRadius)),
                  child: Material(
                    child: ExternalsWidget(
                      songLyric: widget.songLyric,
                      percentage: (_height.value - widget.minHeight) / (widget.maxHeight - widget.minHeight),
                      isPlaying: _isPlaying,
                    ),
                  ),
                ),
                onTap: _expandWidget,
                onPanUpdate: (details) => _changeHeight(_height.value - details.delta.dy),
                onPanEnd: _snapWidget,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateHeight() {
    final double newHeight = widget.isShowing.value ? (_isCollapsed ? widget.minHeight : widget.maxHeight) : 0;

    final heightAnimation = Tween(
      begin: _height.value,
      end: newHeight,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    heightAnimation.addListener(() {
      if (heightAnimation.value == _height.value) return;

      _changeHeight(heightAnimation.value);
    });

    _animationController.forward(from: 0);
  }

  void _changeHeight(double height) {
    if (height > widget.maxHeight) height = widget.maxHeight;

    if (_isCollapsed && height < widget.minHeight) height = widget.minHeight;

    _height.value = height;
  }

  void _snapWidget(DragEndDetails details) {
    if (_height.value - _dragSpeedScale * details.velocity.pixelsPerSecond.dy < widget.maxHeight / 2) {
      _collapseOrHide();
    } else {
      _expandWidget();
    }
  }

  void _expandWidget() {
    if (_isCollapsed) _isCollapsed = false;

    _updateHeight();
  }

  void _collapseOrHide() {
    if (_isPlaying.value) {
      _isCollapsed = true;

      _updateHeight();
    } else {
      widget.isShowing.value = false;
    }
  }

  void _isPlayingChanged() {
    if (!_isPlaying.value && _isCollapsed) {
      _isCollapsed = false;
      widget.isShowing.value = false;
    }
  }
}
