import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart' as reorderable;
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/components/highlightable_button.dart';
import 'package:zpevnik/screens/components/search_widget.dart';
import 'package:zpevnik/screens/components/song_lyrics_list.dart';
import 'package:zpevnik/screens/song_lyric/song_lyric_screen.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/platform/mixin.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoriteScreenState(SongLyricsProvider(
      DataProvider.shared.songLyrics.where((songLyric) => songLyric.isFavorite).toList()
        ..sort((first, second) => first.entity.favoriteOrder.compareTo(second.entity.favoriteOrder))));
}

class _FavoriteScreenState extends State<FavoriteScreen> with PlatformStateMixin {
  final SongLyricsProvider _songLyricsProvider;

  final _searchFieldFocusNode = FocusNode();

  bool _searching;

  _FavoriteScreenState(this._songLyricsProvider);

  @override
  void initState() {
    super.initState();

    _searching = false;
  }

  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: _leading(context),
          middle: _middle(context),
          trailing: _trailing(context),
          padding: _searching
              ? EdgeInsetsDirectional.only(start: kDefaultPadding / 2, end: kDefaultPadding / 2)
              : EdgeInsetsDirectional.zero,
        ),
        child: _body(context),
      );

  @override
  Widget androidWidget(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: _leading(context),
          title: _middle(context),
          titleSpacing: kDefaultPadding,
          actions: [_trailing(context)],
          leadingWidth: _searching ? 0 : null,
          shadowColor: AppTheme.of(context).appBarDividerColor,
          brightness: AppTheme.of(context).brightness,
        ),
        body: _body(context),
      );

  Widget _leading(BuildContext context) => _searching ? Container(width: 0) : null;

  Widget _middle(BuildContext context) => _searching
      ? SearchWidget(
          key: PageStorageKey('favorite_search_widget'),
          placeholder: 'Zadejte slovo nebo číslo',
          search: _songLyricsProvider.search,
          onSubmitted: (_) => _pushSelectedSongLyric(context),
          focusNode: _searchFieldFocusNode,
          prefix: HighlightableButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => setState(() {
              _songLyricsProvider.search('');
              _searching = false;
            }),
          ),
          suffix: HighlightableButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _songLyricsProvider.tagsProvider.showFilters(context),
          ),
        )
      : Text('Písně s hvězdičkou', style: AppTheme.of(context).navBarTitleTextStyle);

  Widget _trailing(BuildContext context) => _searching
      ? Container(width: 0)
      : HighlightableButton(
          onPressed: () => setState(() {
            _searching = true;
            _searchFieldFocusNode.requestFocus();
          }),
          icon: Icon(Icons.search),
        );

  Widget _body(BuildContext context) => SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: kDefaultPadding),
          child: ChangeNotifierProvider.value(
            value: _songLyricsProvider,
            child: Scrollbar(
              child: Consumer<SongLyricsProvider>(
                builder: (context, provider, child) => reorderable.ReorderableList(
                  onReorder: (Key from, Key to) {
                    int fromIndex = provider.songLyrics.indexWhere((songLyric) => songLyric.key == from);
                    int toIndex = provider.songLyrics.indexWhere((songLyric) => songLyric.key == to);

                    final songLyric = provider.songLyrics[fromIndex];
                    setState(() {
                      provider.songLyrics.removeAt(fromIndex);
                      provider.songLyrics.insert(toIndex, songLyric);
                    });
                    return true;
                  },
                  onReorderDone: (_) {
                    for (int i = 0; i < provider.songLyrics.length; i++) provider.songLyrics[i].favoriteOrder = i;
                  },
                  child: SongLyricsListView(
                    placeholder:
                        'Nemáte vybrané žádné oblíbené písně. Píseň si můžete přidat do oblíbených v${unbreakableSpace}náhledu písně.',
                    title: 'Písně s hvězdičkou',
                    titleColor: red,
                    reorderable: true,
                    showStar: false,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  void _pushSelectedSongLyric(BuildContext context) {
    if (_songLyricsProvider.matchedById == null) return;

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SongLyricScreen(songLyric: _songLyricsProvider.matchedById)));
  }
}
