import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/custom/custom_appbar.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/full_screen_provider.dart';
import 'package:zpevnik/providers/scroll_provider.dart';
import 'package:zpevnik/providers/settings_provider.dart';
import 'package:zpevnik/screens/components/data_container.dart';
import 'package:zpevnik/screens/components/highlightable_button.dart';
import 'package:zpevnik/screens/song_lyric/components/lyrics_widget.dart';
import 'package:zpevnik/screens/song_lyric/components/sliding_widget.dart';
import 'package:zpevnik/screens/song_lyric/components/song_lyric_menu.dart';
import 'package:zpevnik/screens/song_lyric/components/song_lyric_settings.dart';
import 'package:zpevnik/screens/song_lyric/externals_widget.dart';
import 'package:zpevnik/screens/song_lyric/translations_screen.dart';
import 'package:zpevnik/status_bar_wrapper.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

class SongLyricScreen extends StatefulWidget {
  final SongLyric songLyric;

  const SongLyricScreen({Key key, this.songLyric}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongLyricScreen();
}

class _SongLyricScreen extends State<SongLyricScreen> with PlatformStateMixin {
  ScrollProvider _scrollProvider;

  ValueNotifier<bool> _showingMenu;

  @override
  void initState() {
    super.initState();

    _scrollProvider = ScrollProvider();
    _scrollProvider.scrollController = ScrollController();

    _showingMenu = ValueNotifier(false);

    widget.songLyric.addListener(_update);
  }

  @override
  void didUpdateWidget(covariant SongLyricScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    _scrollProvider.scrollController = ScrollController();
  }

  @override
  Widget iOSWidget(BuildContext context) => Consumer<FullScreenProvider>(
        builder: (context, provider, _) => WillPopScope(
          onWillPop: provider.fullScreen ? () async => !Navigator.of(context).userGestureInProgress : null,
          child: CupertinoPageScaffold(
            navigationBar: provider.fullScreen
                ? null
                : CupertinoNavigationBar(
                    middle: Text(widget.songLyric.id.toString(), style: AppTheme.of(context).navBarTitleTextStyle),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: _actions(context)),
                    padding: EdgeInsetsDirectional.only(start: kDefaultPadding, end: kDefaultPadding),
                  ),
            child: _body(context),
          ),
        ),
      );

  @override
  Widget androidWidget(BuildContext context) => Consumer<FullScreenProvider>(
        builder: (context, provider, _) => StatusBarWrapper(
          child: Scaffold(
            appBar: provider.fullScreen
                ? null
                : CustomAppBar(
                    title: Text(
                      widget.songLyric.id.toString(),
                      style: AppTheme.of(context).navBarTitleTextStyle.copyWith(color: AppTheme.of(context).iconColor),
                    ),
                    shadowColor: AppTheme.of(context).appBarDividerColor,
                    actions: _actions(context),
                    brightness: AppTheme.of(context).brightness,
                  ),
            body: _body(context),
          ),
        ),
      );

  Widget _body(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final fullScreenProvider = Provider.of<FullScreenProvider>(context, listen: false);

    return DataContainer(
      data: widget.songLyric,
      child: SafeArea(
        child: GestureDetector(
          onScaleStart: settingsProvider.fontScaleStarted,
          onScaleUpdate: settingsProvider.fontScaleUpdated,
          onTap: () {
            _showingMenu.value = false;
            fullScreenProvider.toggle();
          },
          child: Stack(
            children: [
              NotificationListener(
                onNotification: (notif) {
                  if (notif is ScrollEndNotification) setState(() => _scrollProvider.scrollEnded());

                  if (notif is ScrollUpdateNotification) {
                    // fixme: prevents scroll first time
                    // fullScreenProvider.fullScreen = true;
                    _showingMenu.value = false;
                  }

                  return true;
                },
                child: Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    restorationId: 'song_lyric_scroll_view_${widget.songLyric.id}',
                    key: PageStorageKey('song_lyric_scroll_view_${widget.songLyric.id}'),
                    controller: _scrollProvider.scrollController,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        kDefaultPadding,
                        kDefaultPadding,
                        kDefaultPadding,
                        6 * kDefaultPadding,
                      ),
                      child: LyricsWidget(songLyric: widget.songLyric),
                    ),
                  ),
                ),
              ),
              Positioned(right: 0, child: SongLyricMenu(showing: _showingMenu)),
              if (settingsProvider.showBottomOptions)
                Positioned(
                  right: 0,
                  bottom: kDefaultPadding,
                  child: DataContainer(
                    data: _scrollProvider,
                    child: SlidingWidget(
                      showSettings: _showSettings,
                      showExternals: widget.songLyric.youtubes.isNotEmpty ? _showExternals : null,
                      scrollProvider: _scrollProvider,
                      hasExternals: widget.songLyric.hasExternals,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _actions(BuildContext context) {
    final padding = EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding);

    return [
      if (widget.songLyric.hasTranslations)
        HighlightableButton(
          icon: Icon(Icons.translate),
          padding: padding,
          onPressed: () => _pushTranslateScreen(context),
        ),
      HighlightableButton(
        icon: Icon(widget.songLyric.isFavorite ? Icons.star : Icons.star_outline),
        padding: padding,
        onPressed: widget.songLyric.toggleFavorite,
      ),
      HighlightableButton(
        icon: Icon(Icons.more_vert),
        padding: padding.copyWith(right: AppTheme.of(context).platform == TargetPlatform.android ? kDefaultPadding : 0),
        onPressed: () => _showingMenu.value = !_showingMenu.value,
      ),
    ];
  }

  void _showSettings() => showPlatformBottomSheet(
        context: context,
        child: ChangeNotifierProvider.value(
          value: widget.songLyric,
          child: SongLyricSettings(),
        ),
        height: 0.67 * MediaQuery.of(context).size.height,
      );

  void _showExternals() => showPlatformBottomSheet(
        context: context,
        child: ExternalsWidget(songLyric: widget.songLyric),
        height: 0.67 * MediaQuery.of(context).size.height,
      );

  void _pushTranslateScreen(BuildContext context) {
    // if user came here from translation screen pop back instead of pushing to new
    // so user can't keep infinitely pushing new screens
    // fixme: doesn't work now
    if (DataContainer.of<SongLyric>(context) != null)
      Navigator.of(context).pop();
    else
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DataContainer(child: TranslationsScreen(), data: widget.songLyric),
        ),
      );
  }

  void _update() => setState(() => {});

  @override
  void dispose() {
    widget.songLyric.removeListener(_update);

    super.dispose();
  }
}
