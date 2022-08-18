import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/home/nearby_song_lyrics/nearby_publisher_cell.dart';
import 'package:zpevnik/components/song_lyric/now_playing_song_lyric.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/nearby_song_lyrics.dart';

class NowPlayingBanner extends ConsumerStatefulWidget {
  final SongLyric? currentSongLyric;

  const NowPlayingBanner({Key? key, this.currentSongLyric}) : super(key: key);

  @override
  ConsumerState<NowPlayingBanner> createState() => _NowPlayingBannerState();
}

class _NowPlayingBannerState extends ConsumerState<NowPlayingBanner> {
  SongLyric? _currentSongLyric;

  bool _isShowing = false;

  late Function() _removeListener;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _currentSongLyric = widget.currentSongLyric;

    _removeListener = ref.read(nearbySongLyricProvider.notifier).addListener(_nowPlayingChanged);
  }

  @override
  void dispose() {
    _removeListener();
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
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: _currentSongLyric == null ? Container() : NowPlayingSongLyric(songLyric: _currentSongLyric!),
            ),
          ),
        ),
      ),
    );
  }

  void _nowPlayingChanged(int songLyricId) {
    if (_currentSongLyric?.id != songLyricId) {
      _currentSongLyric = context.read<DataProvider>().getSongLyricById(songLyricId);

      setState(() => _isShowing = true);

      _timer?.cancel();
      _timer = Timer(const Duration(seconds: 10), () => setState(() => _isShowing = false));
    }
  }
}
