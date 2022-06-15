import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/song_lyric/externals_player_wrapper.dart';
import 'package:zpevnik/components/song_lyric/lyrics.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_settings.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/screens/song_lyric/utils/lyrics_controller.dart';

const double _navigationBarHeight = 48;

const double _miniPlayerHeight = 64;

const double _settingsMaxHeight = 300;

class SongLyricScreen extends StatefulWidget {
  final SongLyric songLyric;
  const SongLyricScreen({Key? key, required this.songLyric}) : super(key: key);

  @override
  State<SongLyricScreen> createState() => _SongLyricScreenState();
}

class _SongLyricScreenState extends State<SongLyricScreen> {
  late final LyricsController _lyricsController;

  late final ValueNotifier<bool> _showingExternals;

  bool _fullscreen = false;

  @override
  void initState() {
    super.initState();

    _lyricsController = LyricsController(widget.songLyric, context);

    _showingExternals = ValueNotifier(false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final height = MediaQuery.of(context).size.height;

    AppBar? appBar;
    NavigationBar? navigationBar;

    if (!_fullscreen) {
      appBar = AppBar(
        title: Text('${widget.songLyric.id}', style: theme.textTheme.titleMedium),
        centerTitle: false,
        leading: const CustomBackButton(),
        elevation: 1,
      );

      navigationBar = NavigationBar(
        height: _navigationBarHeight,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (destination) => _destinationSelected(context, destination),
        destinations: [
          _buildDestination(context, FontAwesomeIcons.headphones),
          _buildDestination(context, Icons.insert_drive_file),
          _buildDestination(context, Icons.tune),
          _buildDestination(context, Icons.search),
        ],
      );
    }

    return Theme(
      data: theme.copyWith(
        navigationBarTheme: theme.navigationBarTheme.copyWith(indicatorColor: Colors.transparent),
      ),
      child: Stack(
        children: [
          Scaffold(
            appBar: appBar,
            body: SafeArea(child: _buildLyrics(context)),
            bottomNavigationBar: navigationBar,
          ),
          ExternalsPlayerWrapper(
            songLyric: widget.songLyric,
            maxHeight: 2 / 3 * height,
            minHeight: _miniPlayerHeight,
            isShowing: _showingExternals,
          ),
        ],
      ),
    );
  }

  Widget _buildLyrics(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _fullscreen = !_fullscreen),
      child: LyricsWidget(controller: _lyricsController),
    );
  }

  Widget _buildDestination(BuildContext context, IconData icon) {
    return Highlightable(
      child: NavigationDestination(
        label: '',
        icon: Icon(icon),
      ),
    );
  }

  void _destinationSelected(BuildContext context, int destination) {
    switch (destination) {
      case 0:
        _showingExternals.value = true;
        break;
      case 1:
        break;
      case 2:
        _showSettings(context);
        break;
      case 3:
        break;
    }
  }

  void _showSettings(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
      builder: (context) => SizedBox(
        height: min(2 / 3 * MediaQuery.of(context).size.height, _settingsMaxHeight),
        child: SongLyricSettingsWidget(controller: _lyricsController),
      ),
      useRootNavigator: true,
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:zpevnik/constants.dart';
// import 'package:zpevnik/custom/listenable_builder.dart';
// import 'package:zpevnik/models/song_lyric.dart';
// import 'package:zpevnik/platform/components/navigation_bar.dart';
// import 'package:zpevnik/platform/components/scaffold.dart';
// import 'package:zpevnik/platform/utils/route_builder.dart';
// import 'package:zpevnik/providers/data.dart';
// import 'package:zpevnik/components/highlightable.dart';
// import 'package:zpevnik/screens/song_lyric/components/bottom_menu.dart';
// import 'package:zpevnik/screens/song_lyric/components/song_lyric_menu.dart';
// import 'package:zpevnik/screens/song_lyric/lyrics.dart';
// import 'package:zpevnik/screens/song_lyric/translations.dart';
// import 'package:zpevnik/screens/song_lyric/utils/lyrics_lyricsController.dart';
// import 'package:zpevnik/theme.dart';

// class SongLyricPageView extends StatefulWidget {
//   final List<SongLyric> songLyrics;
//   final int initialSongLyricIndex;

//   const SongLyricPageView({Key? key, required this.songLyrics, this.initialSongLyricIndex = 0}) : super(key: key);

//   @override
//   State<SongLyricPageView> createState() => _SongLyricPageViewState();
// }

// class _SongLyricPageViewState extends State<SongLyricPageView> {
//   late final PageController _pageController;

//   final Map<int, LyricsController> _lyricsControllers = {};

//   late int _currentIndex;

//   bool _isShowingMenu = false;

//   @override
//   void initState() {
//     super.initState();

//     _currentIndex = widget.initialSongLyricIndex;

//     // adding songlyrics length multiple times to initial page, so we can swipe through songlyrics cyclically
//     final initialPage = widget.songLyrics.length == 1 ? 0 : widget.initialSongLyricIndex + 5 * widget.songLyrics.length;
//     _pageController = PageController(initialPage: initialPage);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final lyricsController =
//         _lyricsControllers.putIfAbsent(_currentIndex, () => LyricsController(widget.songLyrics[_currentIndex]));

//     return PlatformScaffold(
//       navigationBar: PlatformNavigationBar(
//         title: lyricsController.songLyric.id.toString(),
//         trailing: _buildActions(context, lyricsController.songLyric),
//       ),
//       child: Stack(fit: StackFit.expand, children: [
//         PageView.builder(
//           controller: _pageController,
//           itemCount: widget.songLyrics.length == 1 ? 1 : null,
//           physics: widget.songLyrics.length == 1 ? const NeverScrollableScrollPhysics() : null,
//           itemBuilder: (_, __) => LyricsWidget(lyricsController: lyricsController),
//           onPageChanged: _pageChanged,
//         ),
//         Positioned(
//           right: 0,
//           bottom: kDefaultPadding,
//           child: RepaintBoundary(child: BottomMenu(lyricsController: lyricsController)),
//         ),
//         Positioned(
//           right: 0,
//           top: 0,
//           child: SongLyricMenu(lyricsController: lyricsController, isShowing: _isShowingMenu),
//         ),
//       ]),
//     );
//   }

//   Widget _buildActions(BuildContext context, SongLyric songLyric) {
//     final dataProvider = context.read<DataProvider>();

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (dataProvider.hasTranslations(songLyric))
//           Highlightable(
//             padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
//             child: const Icon(Icons.translate),
//             onTap: () => _pushTranslations(context, songLyric),
//           ),
//         StatefulBuilder(
//           builder: (_, setState) => Highlightable(
//             padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
//             child: Icon(songLyric.isFavorite ? Icons.star : Icons.star_border),
//             onTap: () => setState(() => songLyric.toggleFavorite()),
//           ),
//         ),
//         Highlightable(
//           padding: const EdgeInsets.only(left: kDefaultPadding / 2),
//           child: const Icon(Icons.more_vert),
//           onTap: () => setState(() => _isShowingMenu = !_isShowingMenu),
//         ),
//       ],
//     );
//   }

//   void _pageChanged(int index) {
//     setState(() {
//       _isShowingMenu = false;
//       _currentIndex = index % widget.songLyrics.length;
//     });
//   }

//   void _pushTranslations(BuildContext context, SongLyric songLyric) {
//     // if (widget.fromTranslations)
//     //   Navigator.of(context).pop();
//     // else

//     Navigator.of(context).push(platformRouteBuilder(
//       context,
//       TranslationsScreen(songLyric: songLyric),
//       types: [ProviderType.data, ProviderType.fullScreen, ProviderType.playlist, ProviderType.songLyric],
//     ));
//   }
// }

// enum SwipeDirection { left, right }

// class SSongLyricPageView extends StatefulWidget {
//   final List<SongLyric> songLyrics;
//   final int initialSongLyricIndex;
//   final bool fromTranslations;

//   const SSongLyricPageView({
//     Key? key,
//     required this.songLyrics,
//     this.initialSongLyricIndex = 0,
//     this.fromTranslations = false,
//   }) : super(key: key);

//   @override
//   _SongLyricPageViewState createState() => _SongLyricPageViewState();
// }

// class _SSongLyricPageViewState extends State<SSongLyricPageView> {
//   late PageController controller;

//   late ValueNotifier<bool> _menuCollapsed;

//   late int _currentIndex;

//   late List<LyricsController> _lyricsControllers;

//   // scaling and swiping cannot be captured simultaneosly by `GestureDetector`
//   // custom functions are implemented to handle it
//   Offset? _swipeStartLocation;
//   DateTime? _swipeStartTime;
//   SwipeDirection? _swipeDirection;

//   @override
//   void initState() {
//     super.initState();

//     Future.delayed(
//       Duration(milliseconds: 10),
//       () => context.read<PlayerProvider>().builder = (height, percentage) =>
//           ExternalsWidget(songLyric: widget.songLyrics[widget.initialSongLyricIndex], percentage: percentage),
//     );

//     // adding songlyrics length multiple times to initial page, so we can swipe through songlyrics cyclically
//     final initialPage = widget.songLyrics.length == 1 ? 0 : widget.initialSongLyricIndex + 5 * widget.songLyrics.length;
//     controller = PageController(initialPage: initialPage)..addListener(_pageUpdate);

//     _menuCollapsed = ValueNotifier(true);

//     _currentIndex = widget.initialSongLyricIndex;

//     _lyricsControllers =
//         widget.songLyrics.map((songLyric) => LyricsController(songLyric, context.read<SettingsProvider>())).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final settingsProvider = context.watch<SettingsProvider>();
//     final fullScreenProvider = context.watch<FullScreenProvider>();

//     return WillPopScope(
//       onWillPop: () async {
//         context.read<PlayerProvider>().activePlayerController = null;
//         context.read<PlayerProvider>().miniplayerController.animateToHeight(state: PanelState.DISMISS);

//         return !fullScreenProvider.isFullScreen || !Navigator.of(context).userGestureInProgress;
//       },
//       child: PlatformScaffold(
//         // title: _currentSongLyric.id.toString(),
//         canBeFullscreen: true,
//         // trailing: _actions(context),
//         body: Stack(
//           fit: StackFit.expand,
//           children: [
//             PageView.builder(
//                 itemBuilder: _buildLyrics, controller: controller, itemCount: widget.songLyrics.length == 1 ? 1 : null),
//             Positioned(
//               right: 0,
//               child: SongLyricMenu(lyricsController: _currentLyricsController, collapsed: _menuCollapsed),
//             ),
//             // if (settingsProvider.showBottomOptions && !_currentLyricsController.isProjectionEnabled)
//             // Positioned(
//             //   right: 0,
//             //   bottom: kDefaultPadding,
//             // child: BottomMenu(
//             //   showSettings: _showSettings,
//             //   showExternals: _showExternals,
//             //   scrollProvider: _currentLyricsController.scrollProvider,
//             //   hasExternals: _currentSongLyric.hasExternals,
//             // ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLyrics(BuildContext context, int index) {
//     final lyricsController = _lyricsControllers[index % _lyricsControllers.length];

//     return GestureDetector(
//       onScaleStart: _onScaleStart,
//       onScaleUpdate: _onScaleUpdate,
//       onScaleEnd: _onScaleEnd,
//       onTap: _onTap,
//       behavior: HitTestBehavior.translucent,
//       child: Container(),
//       //  LyricsWidget(
//       //   key: lyricsController.lyricsGlobalKey,
//       // controller: lyricsController,
//       // scrollController: lyricsController.scrollProvider.controller,
//       // ),
//     );
//   }

//   void _showSettings() {
//     showPlatformBottomSheet(
//       context: context,
//       builder: (_) => SongLyricSettingsWidget(songLyricController: _currentLyricsController),
//       height: 0.5 * MediaQuery.of(context).size.height,
//     );
//   }

//   void _showExternals() {
//     context.read<PlayerProvider>().miniplayerController.animateToHeight(state: PanelState.MAX);
//   }

//   void _pageUpdate() {
//     final index = (controller.page ?? 0).round() % widget.songLyrics.length;

//     if (_currentIndex != index) {
//       context.read<PlayerProvider>().builder =
//           (height, percentage) => ExternalsWidget(songLyric: widget.songLyrics[index], percentage: percentage);

//       context.read<PlayerProvider>().activePlayerController = null;
//       context.read<PlayerProvider>().miniplayerController.animateToHeight(state: PanelState.DISMISS);

//       setState(() => _currentIndex = index);
//     }
//   }

//   Widget _actions(BuildContext context) {
//     final padding = EdgeInsets.symmetric(horizontal: kDefaultPadding / 2);

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (_hasTranslations)
//           Highlightable(
//             child: Icon(Icons.translate),
//             onTap: _pushTranslations,
//             padding: padding,
//           ),
//         Highlightable(
//           child: Icon(_currentSongLyric.isFavorite ? Icons.star : Icons.star_border),
//           onTap: () => setState(() => _currentSongLyric.toggleFavorite()),
//           padding: padding,
//         ),
//         Highlightable(
//           child: Icon(Icons.more_vert),
//           onTap: () => _menuCollapsed.value = !_menuCollapsed.value,
//           padding: padding,
//         ),
//       ],
//     );
//   }

//   void _pushTranslations() {
//     if (widget.fromTranslations)
//       Navigator.of(context).pop();
//     else
//       Navigator.of(context).push(platformRouteBuilder(
//         context,
//         TranslationsScreen(songLyric: _currentSongLyric),
//         types: [ProviderType.data, ProviderType.fullScreen, ProviderType.playlist, ProviderType.songLyric],
//       ));
//   }

//   void _onScaleStart(ScaleStartDetails details) {
//     // if there is only one pointer at the start it might be swipe
//     if (details.pointerCount == 1) {
//       _swipeStartLocation = details.focalPoint;
//       _swipeStartTime = DateTime.now();
//     }

//     context.read<SettingsProvider>().fontScaleStarted();
//   }

//   void _onScaleUpdate(ScaleUpdateDetails details) {
//     // if another pointer is added during swipe change it to scale
//     if (details.pointerCount > 1) {
//       _swipeStartLocation = null;
//       _swipeStartTime = null;
//       _swipeDirection = null;
//     } else if (_swipeStartLocation != null) {
//       if (_swipeStartLocation!.dx < details.focalPoint.dx)
//         _swipeDirection = SwipeDirection.right;
//       else
//         _swipeDirection = SwipeDirection.left;
//     }

//     context.read<SettingsProvider>().fontScaleUpdated(details);
//   }

//   void _onScaleEnd(ScaleEndDetails details) {
//     // when person lifts up fingers the `GestureDetector` will detect is as new scale event and custom logic will detect is as swipe
//     // normal swipe will take at least 10μs, so if it is lower just ignore it
//     if (_swipeStartTime != null && DateTime.now().difference(_swipeStartTime!).inMicroseconds > 10000) {
//       if (_swipeDirection == SwipeDirection.right) if (_currentLyricsController.isProjectionEnabled)
//         _currentLyricsController.previousVerse();
//       else if (_swipeDirection == SwipeDirection.left) if (_currentLyricsController.isProjectionEnabled)
//         _currentLyricsController.nextVerse();
//     }

//     _swipeStartLocation = null;
//     _swipeStartTime = null;
//     _swipeDirection = null;
//   }

//   void _onTap() {
//     if (_currentLyricsController.isProjectionEnabled)
//       _currentLyricsController.nextVerse();
//     else if (_menuCollapsed.value) context.read<FullScreenProvider>().toggleFullScreen();

//     _menuCollapsed.value = true;
//   }

//   SongLyric get _currentSongLyric => widget.songLyrics[_currentIndex];

//   LyricsController get _currentLyricsController => _lyricsControllers[_currentIndex];

//   bool get _hasTranslations {
//     return (context.read<DataProvider>().songsSongLyrics(_currentSongLyric.songId ?? -1)?.length ?? 0) > 1;
//   }
// }
