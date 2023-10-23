import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zpevnik/components/home/now_playing_section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/now_playing.dart';

class NowPlayingBanner extends StatefulWidget {
  final SongLyric? currentSongLyric;

  const NowPlayingBanner({super.key, this.currentSongLyric});

  @override
  State<NowPlayingBanner> createState() => _NowPlayingBannerState();
}

class _NowPlayingBannerState extends State<NowPlayingBanner> {
  late NowPlayingController _controller;

  SongLyric? _currentSongLyric;
  bool _isShowing = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _currentSongLyric = widget.currentSongLyric;

    _controller = NowPlayingController();

    _controller.addListener(_nowPlayingChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_nowPlayingChanged);

    _controller.dispose();

    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: kDefaultAnimationDuration,
      offset: Offset(0, _isShowing ? 0 : -1),
      child: GestureDetector(
        onVerticalDragEnd: (details) => (details.primaryVelocity ?? 0) < 0 ? setState(() => _isShowing = false) : null,
        child: const Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: NowPlayingSection(pushShouldReplace: true),
            ),
          ),
        ),
      ),
    );
  }

  void _nowPlayingChanged() {
    if (_currentSongLyric != _controller.value) {
      _currentSongLyric = _controller.value;

      setState(() => _isShowing = true);

      _timer = Timer(const Duration(seconds: 10), () => setState(() => _isShowing = false));
    }
  }
}
