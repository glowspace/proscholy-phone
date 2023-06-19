import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zpevnik/components/song_lyric/externals.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';

const double _miniPlayerHeight = 64;

const double _externalsTitleHeight = 2 * kDefaultPadding + 21;
const double _externalsNameHeight = 2 * kDefaultPadding + 18;

const _dragSpeedScale = 0.01;

class ExternalsPlayerWrapper extends StatefulWidget {
  final SongLyric songLyric;
  final ValueNotifier<bool> isShowing;

  final double width;

  const ExternalsPlayerWrapper({
    super.key,
    required this.songLyric,
    required this.isShowing,
    required this.width,
  });

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

    widget.isShowing.addListener(_updateHeight);
    _isPlaying.addListener(_isPlayingChanged);
  }

  @override
  void didUpdateWidget(covariant ExternalsPlayerWrapper oldWidget) {
    if (_height.value > _minHeight) {
      _height.value = _maxHeight;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.isShowing.removeListener(_updateHeight);
    _isPlaying.removeListener(_isPlayingChanged);

    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: _height,
      builder: (_, height, __) => height == 0
          ? Container()
          : Stack(
              children: [
                if (height > _minHeight)
                  GestureDetector(
                    onTap: _collapseOrHide,
                    child: Opacity(opacity: height / _maxHeight, child: Container(color: Colors.black.withAlpha(0x60))),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: height,
                    child: GestureDetector(
                      onTap: _expandWidget,
                      onPanUpdate: (details) => _changeHeight(_height.value - details.delta.dy),
                      onPanEnd: _snapWidget,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(kDefaultRadius)),
                        child: Material(
                          color: Theme.of(context).canvasColor,
                          child: ExternalsWidget(
                            songLyric: widget.songLyric,
                            percentage: (_height.value - _minHeight) / (_maxHeight - _minHeight),
                            width: widget.width,
                            isPlaying: _isPlaying,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  double get _minHeight => MediaQuery.of(context).padding.bottom + _miniPlayerHeight;
  double get _maxHeight {
    final mediaQuery = MediaQuery.of(context);

    final youtubes = widget.songLyric.youtubes;
    final mp3s = widget.songLyric.mp3s;

    final externalsPerRow = (widget.width / 250).floor();
    final rowsForMp3s =
        ((youtubes.length + mp3s.length) / externalsPerRow).ceil() - (youtubes.length / externalsPerRow).ceil();

    return min(
      2 / 3 * mediaQuery.size.height,
      _externalsTitleHeight +
          (youtubes.length / externalsPerRow).ceil() *
              ((min(widget.width / externalsPerRow, widget.width)) / 16 * 9 + _externalsNameHeight) +
          rowsForMp3s * (64 + kDefaultPadding) +
          kDefaultPadding +
          mediaQuery.padding.bottom,
    );
  }

  void _updateHeight() {
    final double newHeight = widget.isShowing.value ? (_isCollapsed ? _minHeight : _maxHeight) : 0;

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
    if (height > _maxHeight) height = _maxHeight;

    if (_isCollapsed && height < _minHeight) height = _minHeight;

    _height.value = height;
  }

  void _snapWidget(DragEndDetails details) {
    if (_height.value - _dragSpeedScale * details.velocity.pixelsPerSecond.dy < _maxHeight / 2) {
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
