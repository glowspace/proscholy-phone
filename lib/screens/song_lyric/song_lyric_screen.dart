import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/providers/scroll_provider.dart';
import 'package:zpevnik/providers/settings_provider.dart';
import 'package:zpevnik/screens/components/highlightable_button.dart';
import 'package:zpevnik/screens/song_lyric/components/lyrics_widget.dart';
import 'package:zpevnik/screens/song_lyric/components/sliding_widget.dart';
import 'package:zpevnik/screens/song_lyric/components/song_lyric_container.dart';
import 'package:zpevnik/screens/song_lyric/components/song_lyric_menu.dart';
import 'package:zpevnik/screens/song_lyric/components/song_lyric_settings.dart';
import 'package:zpevnik/screens/song_lyric/externals_widget.dart';
import 'package:zpevnik/screens/song_lyric/translations_screen.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

class SongLyricScreen extends StatefulWidget {
  final SongLyric songLyric;

  const SongLyricScreen({Key key, this.songLyric}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongLyricScreen();
}

class _SongLyricScreen extends State<SongLyricScreen> with PlatformStateMixin {
  ScrollController _scrollController;
  ScrollProvider _scrollProvider;

  bool _fullScreen;
  ValueNotifier<bool> _showingMenu;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollProvider = ScrollProvider(_scrollController);

    _fullScreen = false;
    _showingMenu = ValueNotifier(false);

    widget.songLyric.addListener(_update);
  }

  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(widget.songLyric.id.toString()),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: _actions(context)),
          padding: EdgeInsetsDirectional.only(start: kDefaultPadding / 2, end: kDefaultPadding / 2),
        ),
        child: _body(context),
      );

  @override
  Widget androidWidget(BuildContext context) => Scaffold(
        appBar: _fullScreen
            ? null
            : AppBar(
                title: Text(widget.songLyric.id.toString()),
                shadowColor: AppTheme.shared.appBarDividerColor(context),
                actions: _actions(context),
              ),
        body: _body(context),
      );

  Widget _body(BuildContext context) => SongLyricContainer(
        songLyric: widget.songLyric,
        child: SafeArea(
          child: GestureDetector(
            onScaleStart: SettingsProvider.shared.fontScaleStarted,
            onScaleUpdate: SettingsProvider.shared.fontScaleUpdated,
            onTap: _toggleFullScreen,
            child: Stack(
              children: [
                NotificationListener(
                  onNotification: (notif) {
                    if (notif is ScrollEndNotification) setState(() => _scrollProvider.scrollEnded());

                    return true;
                  },
                  child: Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: kDefaultPadding, horizontal: kDefaultPadding / 2),
                        child: ChangeNotifierProvider.value(
                          value: SettingsProvider.shared,
                          child: LyricsWidget(songLyric: widget.songLyric),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(right: 0, child: SongLyricMenu(showing: _showingMenu)),
                if (SettingsProvider.shared.showBottomOptions)
                  Positioned(
                    right: 0,
                    bottom: kDefaultPadding,
                    child: ChangeNotifierProvider.value(
                      value: _scrollProvider,
                      child: SlidingWidget(
                        showSettings: _showSettings,
                        showExternals: widget.songLyric.youtubes.isNotEmpty ? _showExternals : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

  List<Widget> _actions(BuildContext context) {
    final padding = EdgeInsets.symmetric(horizontal: kDefaultPadding / 3, vertical: 2 * kDefaultPadding / 3);

    return [
      if (widget.songLyric.hasTranslations)
        HighlightableButton(
          icon: Icons.translate,
          padding: padding,
          onPressed: () => _pushTranslateScreen(context),
        ),
      HighlightableButton(
        icon: widget.songLyric.isFavorite ? Icons.star : Icons.star_outline,
        padding: padding,
        onPressed: widget.songLyric.toggleFavorite,
      ),
      HighlightableButton(
        icon: Icons.more_vert,
        padding: padding,
        onPressed: () => _showingMenu.value = !_showingMenu.value,
      ),
    ];
  }

  void _showSettings() => showPlatformBottomSheet(
        context: context,
        child: ChangeNotifierProvider.value(
          value: widget.songLyric,
          child: ChangeNotifierProvider.value(value: SettingsProvider.shared, child: SongLyricSettings()),
        ),
        height: 0.67 * MediaQuery.of(context).size.height,
      );

  void _showExternals() => showPlatformBottomSheet(
      context: context,
      child: ExternalsWidget(songLyric: widget.songLyric),
      height: 0.67 * MediaQuery.of(context).size.height);

  void _pushTranslateScreen(BuildContext context) {
    // if user came here from translation screen pop back instead of pushing to new
    // so user can't keep infinitely pushing new screens
    // fixme: doesn't work now
    if (SongLyricContainer.of(context) != null)
      Navigator.of(context).pop();
    else
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SongLyricContainer(child: TranslationsScreen(), songLyric: widget.songLyric),
        ),
      );
  }

  void _toggleFullScreen() => setState(() {
        _showingMenu.value = false;
        _fullScreen = !_fullScreen;
      });

  void _update() => setState(() => {});

  @override
  void dispose() {
    widget.songLyric.removeListener(_update);

    super.dispose();
  }
}
