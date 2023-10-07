import 'package:flutter/material.dart' hide PopupMenuEntry, PopupMenuItem;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/playlist/playlists_sheet.dart';
import 'package:zpevnik/components/song_lyric/bottom_bar.dart';
import 'package:zpevnik/components/song_lyric/song_lyric.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_menu_button.dart';
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

  late double _fontSizeScaleBeforeScale;

  bool _fullScreen = false;

  int get _currentIndex =>
      _pageController.positions.isNotEmpty ? _pageController.page?.round() ?? widget.initialIndex : widget.initialIndex;
  SongLyric get songLyric => widget.songLyrics[_currentIndex % widget.songLyrics.length];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _pageController,
      builder: (_, __) => CustomScaffold(
        appBar: _fullScreen
            ? null
            : AppBar(
                title: Text('${songLyric.id}'),
                leading: const CustomBackButton(),
                actions: [
                  StatefulBuilder(
                    builder: (context, setState) => Highlightable(
                      onTap: () => setState(() => ref.read(playlistsProvider.notifier).toggleFavorite(songLyric)),
                      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      icon: Icon(songLyric.isFavorite ? Icons.star : Icons.star_outline),
                    ),
                  ),
                  Highlightable(
                    onTap: () => _showPlaylists(context),
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    icon: const Icon(Icons.playlist_add),
                  ),
                  SongLyricMenuButton(songLyric: songLyric, songLyricsParser: SongLyricsParser(songLyric)),
                ],
              ),
        bottomNavigationBar: _fullScreen
            ? const SizedBox()
            : SongLyricBottomBar(
                songLyric: songLyric,
                autoScrollController: ref.read(autoScrollControllerProvider(songLyric)),
                toggleFullScreen: () => setState(() => _fullScreen = !_fullScreen),
              ),
        hideNavigationRail: context.isPlaylist,
        body: SafeArea(
          bottom: false,
          child: GestureDetector(
            onScaleStart: _fontScaleStarted,
            onScaleUpdate: _fontScaleUpdated,
            onTap: () => setState(() => _fullScreen = false),
            behavior: HitTestBehavior.translucent,
            child: PageView.builder(
              controller: _pageController,
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
      builder: (context) => PlaylistsSheet(selectedSongLyric: songLyric),
    );
  }
}
