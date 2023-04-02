import 'dart:async';

import 'package:flutter/material.dart' hide PopupMenuEntry, PopupMenuItem;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/presentation/settings.dart';
import 'package:zpevnik/components/song_lyric/externals_player_wrapper.dart';
import 'package:zpevnik/components/song_lyric/lyrics.dart';
import 'package:zpevnik/components/song_lyric/now_playing_banner.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_files.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_menu_button.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_settings.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_tags.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/components/song_lyric/utils/lyrics_controller.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/providers/presentation.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/utils/extensions.dart';

class SongLyricScreen extends StatefulWidget {
  final List<SongLyric> songLyrics;
  final int initialIndex;

  final bool shouldShowBanner;

  final Playlist? playlist;

  const SongLyricScreen({
    Key? key,
    required this.songLyrics,
    required this.initialIndex,
    this.shouldShowBanner = false,
    this.playlist,
  }) : super(key: key);

  @override
  State<SongLyricScreen> createState() => _SongLyricScreenState();
}

class _SongLyricScreenState extends State<SongLyricScreen> {
  late final PageController _pageController;
  late final ValueNotifier<bool> _showingExternals;

  StreamSubscription<List<SongLyric>>? _songLyricsSubscription;

  late List<LyricsController> _lyricsControllers;

  late int _currentIndex;

  bool _fullscreen = false;

  SongLyric get _songLyric => _lyricsController.songLyric;
  LyricsController get _lyricsController => _lyricsControllers[_currentIndex % _lyricsControllers.length];

  @override
  void initState() {
    super.initState();

    // make sure it is possible to swipe to previous song lyric
    _currentIndex = widget.initialIndex + (widget.songLyrics.length == 1 ? 0 : 10 * widget.songLyrics.length);
    _lyricsControllers = widget.songLyrics.map((songLyric) => LyricsController(songLyric, context)).toList();

    _pageController = PageController(initialPage: _currentIndex);
    _showingExternals = ValueNotifier(false);

    if (widget.playlist != null) {
      _songLyricsSubscription =
          context.read<DataProvider>().watchPlaylistRecordsChanges(widget.playlist!).listen((songLyrics) {
        if (songLyrics.isEmpty) return;

        setState(() {
          _currentIndex =
              (_currentIndex % _lyricsControllers.length) + (songLyrics.length == 1 ? 0 : 10 * songLyrics.length);
          _lyricsControllers = songLyrics.map((songLyric) => LyricsController(songLyric, context)).toList();
          _pageController.jumpToPage(_currentIndex);
        });

        context.read<ValueNotifier<SongLyric?>>().value = _songLyric;
      });
    }
  }

  @override
  void dispose() {
    _songLyricsSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final settingsProvider = context.read<SettingsProvider>();
    final navigationProvider = NavigationProvider.of(context);

    final backgroundColor = theme.brightness.isLight ? theme.colorScheme.surface : theme.scaffoldBackgroundColor;
    final canPopIndividually = navigationProvider.songLyricCanPopIndividually;

    AppBar? appBar;
    Widget? bottomBar;

    if (!_fullscreen) {
      appBar = AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: theme.colorScheme.outlineVariant, height: 1.0),
        ),
        title: Text('${_songLyric.id}', style: theme.textTheme.titleMedium),
        centerTitle: false,
        leading: canPopIndividually
            ? const CustomBackButton()
            : HighlightableIconButton(
                onTap: navigationProvider.toggleFullscreen,
                padding: const EdgeInsets.all(kDefaultPadding).copyWith(left: 2.5 * kDefaultPadding),
                icon: Icon(navigationProvider.isFullScreen ? Icons.close_fullscreen : Icons.open_in_full),
              ),
        actions: [
          if (_songLyric.hasTranslations)
            HighlightableIconButton(
              onTap: () => navigationProvider.popToOrPushNamed('/song_lyric/translations', arguments: _songLyric),
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              icon: const Icon(Icons.translate),
            ),
          StatefulBuilder(
            builder: (context, setState) => HighlightableIconButton(
              onTap: () => setState(() => _toggleFavorite(context)),
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              icon: Icon(_songLyric.isFavorite ? Icons.star : Icons.star_outline),
            ),
          ),
          SongLyricMenuButton(songLyric: _songLyric, songLyricsParser: _lyricsController.parser),
        ],
      );

      final bottomBarActionPadding = mediaQuery.isTablet
          ? const EdgeInsets.symmetric(vertical: kDefaultPadding, horizontal: 3 * kDefaultPadding)
          : const EdgeInsets.all(kDefaultPadding);

      final presentationProvider = context.watch<PresentationProvider>();

      bottomBar = Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant, width: 1))),
        child: Theme(
          // TODO: remove this when the bottom app bar works with material3 correctly (can't change color, small padding)
          data: theme.copyWith(useMaterial3: false),
          child: BottomAppBar(
            color: backgroundColor,
            elevation: 0,
            child: Theme(
              // TODO: remove this when the bottom app bar works with material3 correctly (can't change color, small padding)
              data: theme,
              child: Row(
                mainAxisAlignment: mediaQuery.isTablet ? MainAxisAlignment.end : MainAxisAlignment.spaceAround,
                children: presentationProvider.isPresenting
                    ? [
                        HighlightableIconButton(
                          padding: bottomBarActionPadding,
                          onTap: presentationProvider.prevVerse,
                          icon: Icon(Icons.adaptive.arrow_back),
                        ),
                        HighlightableIconButton(
                          padding: bottomBarActionPadding,
                          onTap: presentationProvider.togglePause,
                          icon: Icon(presentationProvider.isPaused ? Icons.play_arrow : Icons.pause),
                        ),
                        HighlightableIconButton(
                          padding: bottomBarActionPadding,
                          onTap: presentationProvider.nextVerse,
                          icon: Icon(Icons.adaptive.arrow_forward),
                        ),
                        HighlightableIconButton(
                          padding: bottomBarActionPadding,
                          onTap: () => _showSettings(context),
                          icon: const Icon(Icons.tune),
                        ),
                        HighlightableIconButton(
                          padding: bottomBarActionPadding,
                          onTap: () => presentationProvider.stop(),
                          icon: const Icon(Icons.close),
                        ),
                      ]
                    : [
                        HighlightableIconButton(
                          padding: bottomBarActionPadding,
                          onTap: _songLyric.hasRecordings ? () => _showingExternals.value = true : null,
                          icon: const Icon(FontAwesomeIcons.headphones),
                        ),
                        HighlightableIconButton(
                          padding: bottomBarActionPadding,
                          onTap: _songLyric.hasFiles ? () => _showFiles(context) : null,
                          icon: const Icon(Icons.insert_drive_file),
                        ),
                        HighlightableIconButton(
                          padding: bottomBarActionPadding,
                          onTap: _songLyric.hasChords ? () => _showSettings(context) : null,
                          icon: const Icon(Icons.tune),
                        ),
                        HighlightableIconButton(
                          padding: bottomBarActionPadding,
                          onTap: _songLyric.tags.isNotEmpty || _songLyric.songbookRecords.isNotEmpty
                              ? () => _showTags(context)
                              : null,
                          icon: const FaIcon(FontAwesomeIcons.tag),
                        ),
                        HighlightableIconButton(
                          padding: bottomBarActionPadding,
                          onTap: () => navigationProvider.popToOrPushNamed('/search'),
                          icon: const Icon(Icons.search),
                        ),
                      ],
              ),
            ),
          ),
        ),
      );
    }

    final scaffold = Stack(
      children: [
        Scaffold(
          appBar: appBar,
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: GestureDetector(
              onScaleStart: settingsProvider.fontScaleStarted,
              onScaleUpdate: settingsProvider.fontScaleUpdated,
              onTap: () => setState(() => _fullscreen = !_fullscreen),
              behavior: HitTestBehavior.translucent,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _lyricsControllers.length == 1 ? 1 : null,
                onPageChanged: (value) => setState(() {
                  _showingExternals.value = false;
                  _currentIndex = value;
                  context.read<PresentationProvider>().changeSongLyric(_lyricsController.parser);
                  context.read<ValueNotifier<SongLyric?>>().value = _songLyric;
                }),
                itemBuilder: (_, index) => LyricsWidget(
                  controller: _lyricsControllers[index % _lyricsControllers.length],
                ),
              ),
            ),
          ),
          bottomNavigationBar: bottomBar,
        ),
        LayoutBuilder(
          builder: (_, constraints) => ExternalsPlayerWrapper(
            key: Key('${_songLyric.id}'),
            songLyric: _songLyric,
            isShowing: _showingExternals,
            width: constraints.maxWidth,
          ),
        ),
        if (widget.shouldShowBanner) NowPlayingBanner(currentSongLyric: _songLyric),
      ],
    );

    if (canPopIndividually) return scaffold;

    return WillPopScope(onWillPop: () async => false, child: scaffold);
  }

  void _showFiles(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
      builder: (context) => SongLyricFilesWidget(songLyric: _songLyric),
    );
  }

  void _showSettings(BuildContext context) {
    if (context.read<PresentationProvider>().isPresenting) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
        builder: (context) => const PresentationSettingsWidget(),
      );
    } else {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
        builder: (context) => SongLyricSettingsWidget(controller: _lyricsController),
      );
    }
  }

  void _showTags(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
      builder: (context) => SongLyricTags(songLyric: _songLyric),
    );
  }

  void _toggleFavorite(BuildContext context) {
    context.read<DataProvider>().toggleFavorite(_songLyric);
  }
}
