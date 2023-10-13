import 'dart:async';

import 'package:flutter/material.dart' hide PopupMenuEntry, PopupMenuItem;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/playlist/playlists_sheet.dart';
import 'package:zpevnik/components/presentation/settings.dart';
import 'package:zpevnik/components/song_lyric/bottom_bar.dart';
import 'package:zpevnik/components/song_lyric/externals/collapsed_player.dart';
import 'package:zpevnik/components/song_lyric/externals/externals_wrapper.dart';
import 'package:zpevnik/components/song_lyric/song_lyric.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_menu_button.dart';
import 'package:zpevnik/components/song_lyric/utils/active_player_controller.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/auto_scroll.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/providers/presentation.dart';
import 'package:zpevnik/providers/recent_items.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/providers/song_lyric_screen_status.dart';
import 'package:zpevnik/routing/router.dart';

class SongLyricScreen extends ConsumerStatefulWidget {
  final List<SongLyric> songLyrics;
  final int initialIndex;

  const SongLyricScreen({super.key, required this.songLyrics, this.initialIndex = 0});

  @override
  ConsumerState<SongLyricScreen> createState() => _SongLyricScreenState();
}

class _SongLyricScreenState extends ConsumerState<SongLyricScreen> {
  // make sure it is possible to swipe to previous song lyric
  late final _pageController = PageController(initialPage: widget.initialIndex + 100 * widget.songLyrics.length);

  late double _fontSizeScaleBeforeScale;

  Timer? _addRecentSongLyricTimer;

  int get _currentIndex =>
      _pageController.positions.isNotEmpty ? _pageController.page?.round() ?? widget.initialIndex : widget.initialIndex;
  SongLyric get _songLyric => widget.songLyrics[_currentIndex % widget.songLyrics.length];

  @override
  void initState() {
    super.initState();

    _addRecentSongLyricAfterDelay();
  }

  @override
  void dispose() {
    _addRecentSongLyricTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activePlayer = ref.watch(activePlayerProvider);
    final presentation = ref.watch(presentationProvider);

    final fullScreen = ref.watch(songLyricScreenStatusProvider.select((status) => status.fullScreen));

    // TODO: check if it is actually presenting on this device
    final isPresentingOnThisDevice = false;

    final Widget? bottomSheet;

    if (presentation.isPresenting) {
      bottomSheet = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding),
        child: Row(children: [
          Highlightable(
            onTap: presentation.prevVerse,
            icon: Icon(Icons.adaptive.arrow_back),
          ),
          Highlightable(
            onTap: presentation.togglePause,
            icon: Icon(presentation.isPaused ? Icons.play_arrow : Icons.pause),
          ),
          Highlightable(
            onTap: presentation.nextVerse,
            icon: Icon(Icons.adaptive.arrow_forward),
          ),
          const Spacer(),
          Highlightable(
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (context) => const PresentationSettingsWidget(),
            ),
            icon: const Icon(Icons.tune),
          ),
          Highlightable(
            onTap: () => presentation.stop(),
            icon: const Icon(Icons.close),
          ),
        ]),
      );
    } else if (activePlayer != null) {
      bottomSheet = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: ref.read(songLyricScreenStatusProvider.notifier).showExternals,
        child: CollapsedPlayer(
          controller: activePlayer,
          onDismiss: ref.read(activePlayerProvider.notifier).dismiss,
        ),
      );
    } else {
      bottomSheet = null;
    }

    return ListenableBuilder(
      listenable: _pageController,
      builder: (_, __) => ExternalsWrapper(
        songLyric: _songLyric,
        child: CustomScaffold(
          appBar: (fullScreen || isPresentingOnThisDevice)
              ? null
              : AppBar(
                  title: Text('${_songLyric.id}'),
                  leading: const CustomBackButton(),
                  actions: [
                    StatefulBuilder(
                      builder: (context, setState) => Highlightable(
                        onTap: () => setState(() => ref.read(playlistsProvider.notifier).toggleFavorite(_songLyric)),
                        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        icon: Icon(_songLyric.isFavorite ? Icons.star : Icons.star_outline),
                      ),
                    ),
                    Highlightable(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => PlaylistsSheet(selectedSongLyric: _songLyric),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      icon: const Icon(Icons.playlist_add),
                    ),
                    SongLyricMenuButton(songLyric: _songLyric),
                  ],
                ),
          bottomNavigationBar: (fullScreen || isPresentingOnThisDevice)
              ? const SizedBox()
              : SongLyricBottomBar(
                  songLyric: _songLyric,
                  autoScrollController: ref.read(autoScrollControllerProvider(_songLyric)),
                ),
          bottomSheet: bottomSheet,
          hideNavigationRail: context.isPlaylist,
          body: GestureDetector(
            onScaleStart: _fontScaleStarted,
            onScaleUpdate: _fontScaleUpdated,
            onTap: ref.read(songLyricScreenStatusProvider.notifier).toggleFullScreen,
            behavior: HitTestBehavior.translucent,
            child: SafeArea(
              bottom: false,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (_) {
                  _addRecentSongLyricAfterDelay();
                  ref.read(activePlayerProvider.notifier).dismiss();
                },
                // disable scrolling when there is only one song lyric
                physics: widget.songLyrics.length == 1 ? const NeverScrollableScrollPhysics() : null,
                itemBuilder: (_, index) => SongLyricWidget(
                  songLyric: widget.songLyrics[index % widget.songLyrics.length],
                  autoScrollController:
                      ref.read(autoScrollControllerProvider(widget.songLyrics[index % widget.songLyrics.length])),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _fontScaleStarted(ScaleStartDetails _) {
    _fontSizeScaleBeforeScale = ref.read(settingsProvider.select((settings) => settings.fontSizeScale));
  }

  void _fontScaleUpdated(ScaleUpdateDetails details) {
    ref.read(settingsProvider.notifier).changeFontSizeScale(_fontSizeScaleBeforeScale * details.scale);
  }

  // saves song lyric as recent if it was at least for 2 seconds on screen
  void _addRecentSongLyricAfterDelay() {
    _addRecentSongLyricTimer?.cancel();
    _addRecentSongLyricTimer =
        Timer(const Duration(seconds: 2), () => ref.read(recentSongLyricsProvider.notifier).add(_songLyric));
  }
}
