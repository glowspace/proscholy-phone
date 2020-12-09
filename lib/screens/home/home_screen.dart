import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/providers/playlists_provider.dart';
import 'package:zpevnik/providers/selection_provider.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/components/data_container.dart';
import 'package:zpevnik/screens/components/highlightable_button.dart';
import 'package:zpevnik/screens/components/song_lyrics_list.dart';
import 'package:zpevnik/screens/song_lyric/song_lyric_screen.dart';
import 'package:zpevnik/status_bar_wrapper.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';
import 'package:zpevnik/screens/components/search_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with PlatformStateMixin {
  final searchFieldFocusNode = FocusNode();

  SongLyricsProvider _songLyricsProvider;
  SelectionProvider _selectionProvider;

  @override
  void initState() {
    super.initState();

    // fixme: there might be better way to persist this, but I don't know it yet
    _songLyricsProvider = PageStorage.of(context)?.readState(context) as SongLyricsProvider ??
        SongLyricsProvider(DataProvider.shared.songLyrics);

    PageStorage.of(context)?.writeState(context, _songLyricsProvider);

    _selectionProvider = SelectionProvider();
    _selectionProvider.addListener(_update);
  }

  @override
  Widget iOSWidget(BuildContext context) => StatusBarWrapper(
        child: CupertinoPageScaffold(
          navigationBar: _selectionProvider.selectionEnabled
              ? CupertinoNavigationBar(
                  leading: _leading(context),
                  middle: _middle(context),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: _actions(context)),
                  padding: EdgeInsetsDirectional.only(start: kDefaultPadding, end: kDefaultPadding),
                )
              : null,
          child: _body(context),
        ),
      );

  @override
  Widget androidWidget(BuildContext context) => StatusBarWrapper(
        child: Scaffold(
          appBar: _selectionProvider.selectionEnabled
              ? AppBar(
                  leading: _leading(context),
                  title: _middle(context),
                  actions: _selectionProvider.selectionEnabled ? _actions(context) : null,
                  shadowColor: AppTheme.shared.appBarDividerColor(context),
                  brightness: AppThemeNew.of(context).brightness,
                )
              : null,
          body: _body(context),
        ),
      );

  Widget _body(BuildContext context) => SafeArea(
        child: Column(children: [
          if (!_selectionProvider.selectionEnabled)
            Container(padding: EdgeInsets.symmetric(horizontal: kDefaultPadding), child: _searchWidget(context)),
          Expanded(
            child: ChangeNotifierProvider.value(
              value: _songLyricsProvider,
              child: DataContainer(
                data: _selectionProvider,
                child: SongLyricsListView(
                  key: PageStorageKey('home_screen_list_view'),
                  title: 'Abecední seznam všech písní',
                  titleColor: blue,
                ),
              ),
            ),
          ),
        ]),
      );

  Widget _leading(BuildContext context) => HighlightableButton(
        icon: Icon(Icons.close),
        color: AppTheme.shared.selectedRowColor(context),
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 2),
        onPressed: () => setState(() => _selectionProvider.selectionEnabled = false),
      );

  Widget _middle(BuildContext context) => FittedBox(fit: BoxFit.scaleDown, child: Text(_title));

  String get _title {
    if (_selectionProvider.selectedCount == 0)
      return "Nic nevybráno";
    else if (_selectionProvider.selectedCount == 1)
      return "1 píseň";
    else if (_selectionProvider.selectedCount < 5) return "${_selectionProvider.selectedCount} písně";

    return "${_selectionProvider.selectedCount} písní";
  }

  List<Widget> _actions(BuildContext context) {
    final padding = EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 2);

    return [
      HighlightableButton(
        icon: Icon(_selectionProvider.allFavorited ? Icons.star : Icons.star_outline),
        color: AppTheme.shared.selectedRowColor(context),
        padding: padding,
        onPressed: _selectionProvider.selectedCount > 0 ? () => _selectionProvider.toggleFavorite() : null,
      ),
      HighlightableButton(
        icon: Icon(Icons.playlist_add),
        color: AppTheme.shared.selectedRowColor(context),
        padding: padding,
        onPressed: () => PlaylistsProvider.shared.showPlaylists(context, _selectionProvider.selected),
      ),
      HighlightableButton(
        icon: Icon(Icons.select_all),
        color: AppTheme.shared.selectedRowColor(context),
        padding: padding,
        onPressed: () => _selectionProvider.toggleAll(_songLyricsProvider.songLyrics),
      )
    ];
  }

  Widget _searchWidget(BuildContext context) => SearchWidget(
        key: PageStorageKey('home_screen_search_widget'),
        placeholder: 'Zadejte slovo nebo číslo',
        search: _songLyricsProvider.search,
        onSubmitted: (_) => _pushSelectedSongLyric(context),
        focusNode: searchFieldFocusNode,
        prefix: HighlightableButton(
          icon: Icon(Icons.search),
          onPressed: () => FocusScope.of(context).requestFocus(searchFieldFocusNode),
        ),
        suffix: HighlightableButton(
          icon: Icon(Icons.filter_list),
          onPressed: () => _songLyricsProvider.tagsProvider.showFilters(context),
        ),
      );

  void _pushSelectedSongLyric(BuildContext context) {
    if (_songLyricsProvider.matchedById == null) return;

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SongLyricScreen(songLyric: _songLyricsProvider.matchedById)));
  }

  void _update() => setState(() => {});

  @override
  void dispose() {
    _selectionProvider.removeListener(_update);

    super.dispose();
  }
}
