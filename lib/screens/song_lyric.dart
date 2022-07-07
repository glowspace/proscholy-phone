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
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/components/song_lyric/utils/lyrics_controller.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/providers/settings.dart';

const double _miniPlayerHeight = 64;

class SongLyricScreen extends StatefulWidget {
  final SongLyric songLyric;
  const SongLyricScreen({Key? key, required this.songLyric}) : super(key: key);

  @override
  State<SongLyricScreen> createState() => _SongLyricScreenState();
}

class _SongLyricScreenState extends State<SongLyricScreen> {
  late final LyricsController _lyricsController;
  late final ScrollController _scrollController;

  late final ValueNotifier<bool> _showingExternals;

  bool _fullscreen = false;

  @override
  void initState() {
    super.initState();

    _lyricsController = LyricsController(widget.songLyric, context);
    _scrollController = ScrollController();

    _showingExternals = ValueNotifier(false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsProvider = context.read<SettingsProvider>();

    final height = MediaQuery.of(context).size.height;

    AppBar? appBar;
    Widget? bottomBar;

    if (!_fullscreen) {
      appBar = AppBar(
        title: Text('${widget.songLyric.id}', style: theme.textTheme.titleMedium),
        centerTitle: false,
        leading: const CustomBackButton(),
        actions: [
          if (widget.songLyric.hasTranslations)
            Highlightable(
              onTap: () => _popOrPushTranslations(context),
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: const Icon(Icons.translate),
            ),
          StatefulBuilder(
            builder: (context, setState) => Highlightable(
              onTap: () => setState(() => _toggleFavorite(context)),
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Icon(widget.songLyric.isFavorite ? Icons.star : Icons.star_outline),
            ),
          ),
          SongLyricMenuButton(songLyric: widget.songLyric),
        ],
      );

      bottomBar = BottomAppBar(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (widget.songLyric.hasRecordings)
              Highlightable(
                padding: const EdgeInsets.all(kDefaultPadding),
                onTap: () => _showingExternals.value = true,
                child: const Icon(FontAwesomeIcons.headphones),
              ),
            if (widget.songLyric.hasFiles)
              Highlightable(
                padding: const EdgeInsets.all(kDefaultPadding),
                onTap: () => _showFiles(context),
                child: const Icon(Icons.insert_drive_file),
              ),
            Highlightable(
              padding: const EdgeInsets.all(kDefaultPadding),
              onTap: () => _showSettings(context),
              child: const Icon(Icons.tune),
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

    ;

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
              child: LyricsWidget(controller: _lyricsController, scrollController: _scrollController),
            ),
          ),
          bottomNavigationBar: bottomBar,
        ),
        ExternalsPlayerWrapper(
          songLyric: widget.songLyric,
          maxHeight: 2 / 3 * height,
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
      builder: (context) => SongLyricFilesWidget(songLyric: widget.songLyric),
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

  void _popOrPushTranslations(BuildContext context) {
    final navigationProvider = context.read<NavigationProvider>();

    if (navigationProvider.hasTranslationsScreenRoute) {
      Navigator.of(context).popUntil((route) => route == navigationProvider.translationsScreenRoute);
    } else {
      Navigator.of(context).pushNamed('/songLyrics/translations', arguments: widget.songLyric);
    }
  }

  void _popOrPushSearch(BuildContext context) {
    final navigationProvider = context.read<NavigationProvider>();

    if (navigationProvider.hasSearchScreenRoute) {
      Navigator.of(context).popUntil((route) => route == navigationProvider.searchScreenRoute);
    } else {
      Navigator.of(context).pushNamed('/search', arguments: widget.songLyric);
    }
  }

  void _toggleFavorite(BuildContext context) {
    context.read<DataProvider>().toggleFavorite(widget.songLyric);
  }
}
