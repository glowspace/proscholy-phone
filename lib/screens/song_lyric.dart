import 'package:flutter/material.dart' hide PopupMenuEntry, PopupMenuItem;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/playlist/playlists_sheet.dart';
import 'package:zpevnik/components/song_lyric/bottom_bar.dart';
import 'package:zpevnik/components/song_lyric/externals/collapsed_player.dart';
import 'package:zpevnik/components/song_lyric/externals/externals_wrapper.dart';
import 'package:zpevnik/components/song_lyric/song_lyric.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_menu_button.dart';
import 'package:zpevnik/components/song_lyric/utils/active_player_controller.dart';
import 'package:zpevnik/components/song_lyric/utils/parser.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/auto_scroll.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/providers/settings.dart';
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

  final _showingExternals = ValueNotifier(false);

  late double _fontSizeScaleBeforeScale;

  bool _fullScreen = false;

  int get _currentIndex =>
      _pageController.positions.isNotEmpty ? _pageController.page?.round() ?? widget.initialIndex : widget.initialIndex;
  SongLyric get _songLyric => widget.songLyrics[_currentIndex % widget.songLyrics.length];

  @override
  Widget build(BuildContext context) {
    final activePlayer = ref.watch(activePlayerProvider);

    return ListenableBuilder(
      listenable: _pageController,
      builder: (_, __) => ExternalsWrapper(
        songLyric: _songLyric,
        showingExternals: _showingExternals,
        child: GestureDetector(
          onScaleStart: _fontScaleStarted,
          onScaleUpdate: _fontScaleUpdated,
          onTap: () => setState(() => _fullScreen = !_fullScreen),
          behavior: HitTestBehavior.translucent,
          child: CustomScaffold(
            appBar: _fullScreen
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
                        onTap: () => _showPlaylists(context),
                        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        icon: const Icon(Icons.playlist_add),
                      ),
                      SongLyricMenuButton(songLyric: _songLyric, songLyricsParser: SongLyricsParser(_songLyric)),
                    ],
                  ),
            bottomNavigationBar: _fullScreen
                ? const SizedBox()
                : SongLyricBottomBar(
                    songLyric: _songLyric,
                    autoScrollController: ref.read(autoScrollControllerProvider(_songLyric)),
                    toggleFullScreen: () => setState(() => _fullScreen = !_fullScreen),
                    showExternals: () => _showingExternals.value = true,
                  ),
            bottomSheet: activePlayer == null
                ? null
                : GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => _showingExternals.value = true,
                    child: CollapsedPlayer(
                      controller: activePlayer,
                      onDismiss: ref.read(activePlayerProvider.notifier).dismiss,
                    ),
                  ),
            hideNavigationRail: context.isPlaylist,
            body: SafeArea(
              bottom: false,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (_) => ref.read(activePlayerProvider.notifier).dismiss(),
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

  void _showPlaylists(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
      builder: (context) => PlaylistsSheet(selectedSongLyric: _songLyric),
    );
  }
}
