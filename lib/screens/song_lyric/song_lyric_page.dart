import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/platform/components/scaffold.dart';
import 'package:zpevnik/platform/utils/bottom_sheet.dart';
import 'package:zpevnik/platform/utils/route_builder.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/fullscreen.dart';
import 'package:zpevnik/providers/player.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/screens/components/highlightable.dart';
import 'package:zpevnik/screens/song_lyric/components/bottom_menu.dart';
import 'package:zpevnik/screens/song_lyric/components/externals.dart';
import 'package:zpevnik/screens/song_lyric/components/song_lyric_menu.dart';
import 'package:zpevnik/screens/song_lyric/components/song_lyric_settings.dart';
import 'package:zpevnik/screens/song_lyric/lyrics.dart';
import 'package:zpevnik/screens/song_lyric/translations.dart';
import 'package:zpevnik/screens/song_lyric/utils/lyrics_controller.dart';

enum SwipeDirection { left, right }

class SongLyricPageView extends StatefulWidget {
  final List<SongLyric> songLyrics;
  final int initialSongLyricIndex;
  final bool fromTranslations;

  const SongLyricPageView({
    Key? key,
    required this.songLyrics,
    this.initialSongLyricIndex = 0,
    this.fromTranslations = false,
  }) : super(key: key);

  @override
  _SongLyricPageViewState createState() => _SongLyricPageViewState();
}

class _SongLyricPageViewState extends State<SongLyricPageView> {
  late PageController controller;

  late ValueNotifier<bool> _menuCollapsed;

  late int _currentIndex;

  late List<LyricsController> _lyricsControllers;

  // scaling and swiping cannot be captured simultaneosly by `GestureDetector`
  // custom functions are implemented to handle it
  Offset? _swipeStartLocation;
  DateTime? _swipeStartTime;
  SwipeDirection? _swipeDirection;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration(milliseconds: 10),
      () => context.read<PlayerProvider>().builder = (height, percentage) =>
          ExternalsWidget(songLyric: widget.songLyrics[widget.initialSongLyricIndex], percentage: percentage),
    );

    // adding songlyrics length multiple times to initial page, so we can swipe through songlyrics cyclically
    final initialPage = widget.songLyrics.length == 1 ? 0 : widget.initialSongLyricIndex + 5 * widget.songLyrics.length;
    controller = PageController(initialPage: initialPage)..addListener(_pageUpdate);

    _menuCollapsed = ValueNotifier(true);

    _currentIndex = widget.initialSongLyricIndex;

    _lyricsControllers =
        widget.songLyrics.map((songLyric) => LyricsController(songLyric, context.read<SettingsProvider>())).toList();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final fullScreenProvider = context.watch<FullScreenProvider>();

    return WillPopScope(
      onWillPop: () async {
        context.read<PlayerProvider>().activePlayerController = null;
        context.read<PlayerProvider>().miniplayerController.animateToHeight(state: PanelState.DISMISS);

        return !fullScreenProvider.isFullScreen || !Navigator.of(context).userGestureInProgress;
      },
      child: PlatformScaffold(
        title: _currentSongLyric.id.toString(),
        canBeFullscreen: true,
        trailing: _actions(context),
        body: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
                itemBuilder: _buildLyrics, controller: controller, itemCount: widget.songLyrics.length == 1 ? 1 : null),
            Positioned(
              right: 0,
              child: SongLyricMenu(lyricsController: _currentLyricsController, collapsed: _menuCollapsed),
            ),
            if (settingsProvider.showBottomOptions && !_currentLyricsController.isProjectionEnabled)
              Positioned(
                right: 0,
                bottom: kDefaultPadding,
                child: BottomMenu(
                  showSettings: _showSettings,
                  showExternals: _showExternals,
                  scrollProvider: _currentLyricsController.scrollProvider,
                  hasExternals: _currentSongLyric.hasExternals,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLyrics(BuildContext context, int index) {
    final lyricsController = _lyricsControllers[index % _lyricsControllers.length];

    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      onTap: _onTap,
      behavior: HitTestBehavior.translucent,
      child: LyricsWidget(
        key: lyricsController.lyricsGlobalKey,
        controller: lyricsController,
        scrollController: lyricsController.scrollProvider.controller,
      ),
    );
  }

  void _showSettings() {
    showPlatformBottomSheet(
      context: context,
      builder: (_) => SongLyricSettingsWidget(songLyricController: _currentLyricsController),
      height: 0.5 * MediaQuery.of(context).size.height,
    );
  }

  void _showExternals() {
    context.read<PlayerProvider>().miniplayerController.animateToHeight(state: PanelState.MAX);
  }

  void _pageUpdate() {
    final index = (controller.page ?? 0).round() % widget.songLyrics.length;

    if (_currentIndex != index) {
      context.read<PlayerProvider>().builder =
          (height, percentage) => ExternalsWidget(songLyric: widget.songLyrics[index], percentage: percentage);

      context.read<PlayerProvider>().activePlayerController = null;
      context.read<PlayerProvider>().miniplayerController.animateToHeight(state: PanelState.DISMISS);

      setState(() => _currentIndex = index);
    }
  }

  Widget _actions(BuildContext context) {
    final padding = EdgeInsets.symmetric(horizontal: kDefaultPadding / 2);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_hasTranslations)
          Highlightable(
            child: Icon(Icons.translate),
            onPressed: _pushTranslations,
            padding: padding,
          ),
        Highlightable(
          child: Icon(_currentSongLyric.isFavorite ? Icons.star : Icons.star_border),
          onPressed: () => setState(() => _currentSongLyric.toggleFavorite()),
          padding: padding,
        ),
        Highlightable(
          child: Icon(Icons.more_vert),
          onPressed: () => _menuCollapsed.value = !_menuCollapsed.value,
          padding: padding,
        ),
      ],
    );
  }

  void _pushTranslations() {
    if (widget.fromTranslations)
      Navigator.of(context).pop();
    else
      Navigator.of(context).push(platformRouteBuilder(
        context,
        TranslationsScreen(songLyric: _currentSongLyric),
        types: [ProviderType.data, ProviderType.fullScreen, ProviderType.playlist, ProviderType.songLyric],
      ));
  }

  void _onScaleStart(ScaleStartDetails details) {
    // if there is only one pointer at the start it might be swipe
    if (details.pointerCount == 1) {
      _swipeStartLocation = details.focalPoint;
      _swipeStartTime = DateTime.now();
    }

    context.read<SettingsProvider>().fontScaleStarted();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    // if another pointer is added during swipe change it to scale
    if (details.pointerCount > 1) {
      _swipeStartLocation = null;
      _swipeStartTime = null;
      _swipeDirection = null;
    } else if (_swipeStartLocation != null) {
      if (_swipeStartLocation!.dx < details.focalPoint.dx)
        _swipeDirection = SwipeDirection.right;
      else
        _swipeDirection = SwipeDirection.left;
    }

    context.read<SettingsProvider>().fontScaleUpdated(details);
  }

  void _onScaleEnd(ScaleEndDetails details) {
    // when person lifts up fingers the `GestureDetector` will detect is as new scale event and custom logic will detect is as swipe
    // normal swipe will take at least 10μs, so if it is lower just ignore it
    if (_swipeStartTime != null && DateTime.now().difference(_swipeStartTime!).inMicroseconds > 10000) {
      if (_swipeDirection == SwipeDirection.right) if (_currentLyricsController.isProjectionEnabled)
        _currentLyricsController.previousVerse();
      else if (_swipeDirection == SwipeDirection.left) if (_currentLyricsController.isProjectionEnabled)
        _currentLyricsController.nextVerse();
    }

    _swipeStartLocation = null;
    _swipeStartTime = null;
    _swipeDirection = null;
  }

  void _onTap() {
    if (_currentLyricsController.isProjectionEnabled)
      _currentLyricsController.nextVerse();
    else if (_menuCollapsed.value) context.read<FullScreenProvider>().toggleFullScreen();

    _menuCollapsed.value = true;
  }

  SongLyric get _currentSongLyric => widget.songLyrics[_currentIndex];

  LyricsController get _currentLyricsController => _lyricsControllers[_currentIndex];

  bool get _hasTranslations {
    return (context.read<DataProvider>().songsSongLyrics(_currentSongLyric.songId ?? -1)?.length ?? 0) > 1;
  }
}
