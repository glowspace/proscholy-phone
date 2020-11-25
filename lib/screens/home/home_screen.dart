import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/providers/playlists_provider.dart';
import 'package:zpevnik/providers/selection_provider.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/components/highlightable_button.dart';
import 'package:zpevnik/screens/components/song_lyrics_list.dart';
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
        SongLyricsProvider(
          DataProvider.shared.songLyrics,
          selectionProvider: SelectionProvider(),
        );

    PageStorage.of(context)?.writeState(context, _songLyricsProvider);

    _selectionProvider = _songLyricsProvider.selectionProvider;
    _selectionProvider.addListener(_update);
  }

  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            leading: _leading(context),
            middle: _middle(context),
            trailing: _selectionProvider.selectionEnabled
                ? Row(mainAxisSize: MainAxisSize.min, children: _actions(context))
                : null,
            padding: EdgeInsetsDirectional.only(start: kDefaultPadding / 2, end: kDefaultPadding / 2)),
        child: _body(context),
      );

  @override
  Widget androidWidget(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: _leading(context),
          title: _middle(context),
          actions: _selectionProvider.selectionEnabled ? _actions(context) : null,
        ),
        body: _body(context),
      );

  Widget _body(BuildContext context) => SafeArea(
        child: ChangeNotifierProvider.value(
          value: _songLyricsProvider,
          child: SongLyricsListView(key: PageStorageKey('home_screen_list_view')),
        ),
      );

  Widget _leading(BuildContext context) => _selectionProvider.selectionEnabled
      ? HighlightableButton(
          icon: Icons.close,
          color: AppTheme.shared.selectedRowColor(context),
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 4, vertical: 2 * kDefaultPadding / 3),
          onPressed: () => setState(() => _selectionProvider.selectionEnabled = false),
        )
      : null;

  Widget _middle(BuildContext context) => _selectionProvider.selectionEnabled
      ? FittedBox(fit: BoxFit.scaleDown, child: Text(_title))
      : _searchWidget(context);

  String get _title {
    if (_selectionProvider.selectedCount == 0)
      return "Nic nevybráno";
    else if (_selectionProvider.selectedCount == 1)
      return "1 píseň";
    else if (_selectionProvider.selectedCount < 5) return "${_selectionProvider.selectedCount} písně";

    return "${_selectionProvider.selectedCount} písní";
  }

  List<Widget> _actions(BuildContext context) {
    final padding = EdgeInsets.symmetric(horizontal: kDefaultPadding / 3, vertical: 2 * kDefaultPadding / 3);

    return [
      HighlightableButton(
        icon: _selectionProvider.allFavorited ? Icons.star : Icons.star_outline,
        color: AppTheme.shared.selectedRowColor(context),
        padding: padding,
        onPressed: _selectionProvider.selectedCount > 0 ? () => _selectionProvider.toggleFavorite() : null,
      ),
      HighlightableButton(
        icon: Icons.playlist_add,
        color: AppTheme.shared.selectedRowColor(context),
        padding: padding,
        onPressed: () => PlaylistsProvider.shared.showPlaylists(context, _selectionProvider.selected),
      ),
      HighlightableButton(
        icon: Icons.select_all,
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
        focusNode: searchFieldFocusNode,
        prefix: HighlightableButton(
          icon: Icons.search,
          padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          onPressed: () => FocusScope.of(context).requestFocus(searchFieldFocusNode),
        ),
        suffix: HighlightableButton(
          icon: Icons.filter_list,
          padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          onPressed: () => _songLyricsProvider.tagsProvider.showFilters(context),
        ),
      );

  void _update() => setState(() => {});

  @override
  void dispose() {
    _selectionProvider.removeListener(_update);

    super.dispose();
  }
}
