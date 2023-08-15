import 'dart:async';

import 'package:flutter/material.dart' hide PopupMenuEntry, PopupMenuItem;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/playlist/playlists_sheet.dart';
import 'package:zpevnik/components/presentation/settings.dart';
import 'package:zpevnik/components/song_lyric/bottom_bar.dart';
import 'package:zpevnik/components/song_lyric/externals_player_wrapper.dart';
import 'package:zpevnik/components/song_lyric/song_lyric.dart';
import 'package:zpevnik/components/song_lyric/now_playing_banner.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_files.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_menu_button.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_settings.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_tags.dart';
import 'package:zpevnik/components/song_lyric/utils/auto_scroll.dart';
import 'package:zpevnik/components/song_lyric/utils/parser.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/components/song_lyric/utils/lyrics_controller.dart';
import 'package:zpevnik/providers/full_screen.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/providers/presentation.dart';
import 'package:zpevnik/routing/router.dart';
import 'package:zpevnik/utils/extensions.dart';

class SongLyricScreen extends ConsumerStatefulWidget {
  final List<SongLyric> songLyrics;
  final int initialIndex;

  const SongLyricScreen({super.key, required this.songLyrics, required this.initialIndex});

  @override
  ConsumerState<SongLyricScreen> createState() => _SongLyricScreenState();
}

class _SongLyricScreenState extends ConsumerState<SongLyricScreen> {
  // make sure it is possible to swipe to previous song lyric
  late final _pageController = PageController(initialPage: widget.initialIndex + 100 * widget.songLyrics.length);

  // FIXME: will need to change with page change
  final autoScrollController = AutoScrollController();

  int get _currentIndex =>
      _pageController.positions.isNotEmpty ? _pageController.page?.round() ?? widget.initialIndex : widget.initialIndex;
  SongLyric get songLyric => widget.songLyrics[_currentIndex % widget.songLyrics.length];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _pageController,
      builder: (_, __) => CustomScaffold(
        appBar: ref.watch(fullScreenProvider)
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
        bottomNavigationBar: ref.watch(fullScreenProvider)
            ? const SizedBox()
            : SongLyricBottomBar(
                songLyric: songLyric,
                autoScrollController: autoScrollController,
              ),
        body: SafeArea(
          bottom: false,
          child: GestureDetector(
            onTap: ref.read(fullScreenProvider.notifier).disable,
            child: PageView.builder(
              controller: _pageController,
              // disable scrolling when there is only one song lyric
              physics: widget.songLyrics.length == 1 ? const NeverScrollableScrollPhysics() : null,
              itemBuilder: (_, index) => SongLyricWidget(
                songLyric: widget.songLyrics[index % widget.songLyrics.length],
                autoScrollController: autoScrollController,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPlaylists(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
      builder: (context) => PlaylistsSheet(selectedSongLyric: songLyric),
    );
  }
}
