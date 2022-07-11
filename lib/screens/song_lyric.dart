import 'dart:math';

import 'package:flutter/material.dart' hide PopupMenuEntry, PopupMenuItem;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/song_lyric/externals_player_wrapper.dart';
import 'package:zpevnik/components/song_lyric/lyrics.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_files.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_menu_button.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_settings.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_tags.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/components/song_lyric/utils/lyrics_controller.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/providers/settings.dart';

const double _externalsTitleHeight = 2 * kDefaultPadding + 21;
const double _externalsNameHeight = 2 * kDefaultPadding + 18;
const double _miniPlayerHeight = 64;

class SongLyricScreen extends StatefulWidget {
  final List<SongLyric> songLyrics;
  final int initialIndex;

  const SongLyricScreen({
    Key? key,
    required this.songLyrics,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<SongLyricScreen> createState() => _SongLyricScreenState();
}

class _SongLyricScreenState extends State<SongLyricScreen> {
  late final PageController _pageController;
  late final ValueNotifier<bool> _showingExternals;

  late final List<LyricsController> _lyricsControllers;

  late int _currentIndex;

  bool _fullscreen = false;

  SongLyric get _songLyric => widget.songLyrics[_currentIndex % widget.songLyrics.length];
  LyricsController get _lyricsController => _lyricsControllers[_currentIndex % _lyricsControllers.length];

  @override
  void initState() {
    super.initState();

    // make sure it is possible to swipe to previous song lyric
    _currentIndex = widget.initialIndex + (widget.songLyrics.length == 1 ? 0 : 10 * widget.songLyrics.length);
    _lyricsControllers = widget.songLyrics.map((songLyric) => LyricsController(songLyric, context)).toList();

    _pageController = PageController(initialPage: _currentIndex);
    _showingExternals = ValueNotifier(false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsProvider = context.read<SettingsProvider>();

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    AppBar? appBar;
    Widget? bottomBar;

    if (!_fullscreen) {
      appBar = AppBar(
        title: Text('${_songLyric.id}', style: theme.textTheme.titleMedium),
        centerTitle: false,
        leading: const CustomBackButton(),
        actions: [
          if (_songLyric.hasTranslations)
            Highlightable(
              onTap: () => _popOrPushTranslations(context),
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: const Icon(Icons.translate),
            ),
          StatefulBuilder(
            builder: (context, setState) => Highlightable(
              onTap: () => setState(() => _toggleFavorite(context)),
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Icon(_songLyric.isFavorite ? Icons.star : Icons.star_outline),
            ),
          ),
          SongLyricMenuButton(songLyric: _songLyric),
        ],
      );

      bottomBar = BottomAppBar(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (_songLyric.hasRecordings)
              Highlightable(
                padding: const EdgeInsets.all(kDefaultPadding),
                onTap: () => _showingExternals.value = true,
                child: const Icon(FontAwesomeIcons.headphones),
              ),
            if (_songLyric.hasFiles)
              Highlightable(
                padding: const EdgeInsets.all(kDefaultPadding),
                onTap: () => _showFiles(context),
                child: const Icon(Icons.insert_drive_file),
              ),
            if (_songLyric.hasChords)
              Highlightable(
                padding: const EdgeInsets.all(kDefaultPadding),
                onTap: () => _showSettings(context),
                child: const Icon(Icons.tune),
              ),
            if (_songLyric.tags.isNotEmpty || _songLyric.songbookRecords.isNotEmpty)
              Highlightable(
                padding: const EdgeInsets.all(kDefaultPadding),
                onTap: () => _showTags(context),
                child: const FaIcon(FontAwesomeIcons.tag),
              ),
            Highlightable(
              padding: const EdgeInsets.all(kDefaultPadding),
              onTap: () => _popOrPushSearch(context),
              child: const Icon(Icons.search),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        Scaffold(
          appBar: appBar,
          body: SafeArea(
            child: GestureDetector(
              onScaleStart: settingsProvider.fontScaleStarted,
              onScaleUpdate: settingsProvider.fontScaleUpdated,
              onTap: () => setState(() => _fullscreen = !_fullscreen),
              behavior: HitTestBehavior.translucent,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.songLyrics.length == 1 ? 1 : null,
                onPageChanged: (value) => setState(() {
                  _showingExternals.value = false;
                  _currentIndex = value;
                }),
                itemBuilder: (_, index) => LyricsWidget(
                  controller: _lyricsControllers[index % _lyricsControllers.length],
                ),
              ),
            ),
          ),
          bottomNavigationBar: bottomBar,
        ),
        ExternalsPlayerWrapper(
          key: Key('${_songLyric.id}'),
          songLyric: _songLyric,
          // TODO: move this computations to ExternalsPlayerWrapper
          maxHeight: min(
            2 / 3 * height,
            _externalsTitleHeight +
                _songLyric.youtubes.length * (width / 16 * 9 + _externalsNameHeight) +
                kDefaultPadding,
          ),
          minHeight: _miniPlayerHeight,
          isShowing: _showingExternals,
        ),
      ],
    );
  }

  void _showFiles(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
      builder: (context) => SongLyricFilesWidget(songLyric: _songLyric),
      useRootNavigator: true,
    );
  }

  void _showSettings(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
      builder: (context) => SongLyricSettingsWidget(controller: _lyricsController),
      useRootNavigator: true,
    );
  }

  void _showTags(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
      builder: (context) => SongLyricTags(songLyric: _songLyric),
      useRootNavigator: true,
    );
  }

  void _popOrPushTranslations(BuildContext context) {
    final navigationProvider = context.read<NavigationProvider>();

    if (navigationProvider.hasTranslationsScreenRoute) {
      Navigator.of(context).popUntil((route) => route == navigationProvider.translationsScreenRoute);
    } else {
      Navigator.of(context).pushNamed('/song_lyrics/translations', arguments: _songLyric);
    }
  }

  void _popOrPushSearch(BuildContext context) {
    final navigationProvider = context.read<NavigationProvider>();

    if (navigationProvider.hasSearchScreenRoute) {
      Navigator.of(context).popUntil((route) => route == navigationProvider.searchScreenRoute);
    } else {
      Navigator.of(context).pushNamed('/search');
    }
  }

  void _toggleFavorite(BuildContext context) {
    context.read<DataProvider>().toggleFavorite(_songLyric);
  }
}
