import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/components/custom_icon_button.dart';
import 'package:zpevnik/screens/components/search_widget.dart';
import 'package:zpevnik/screens/components/reorderable_row.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoriteScreenState(SongLyricsProvider(
      DataProvider.shared.songLyrics.where((songLyric) => songLyric.isFavorite).toList()
        ..sort((first, second) => first.entity.favoriteOrder.compareTo(second.entity.favoriteOrder))));
}

class _FavoriteScreenState extends State<FavoriteScreen> with PlatformStateMixin {
  final SongLyricsProvider _songLyricsProvider;

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
        ),
        child: _body(context),
      );

  @override
  Widget androidWidget(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: _leading(context),
          title: _middle(context),
          actions: [_trailing(context)],
          leadingWidth: _searching ? 0 : null,
          shadowColor: AppTheme.shared.appBarDividerColor(context),
        ),
        body: _body(context),
      );

  Widget _leading(BuildContext context) => _searching ? Container(width: 0) : null;

  Widget _middle(BuildContext context) => _searching
      ? SearchWidget(
          key: PageStorageKey('favorite_search_widget'),
          placeholder: 'Zadejte slovo nebo číslo',
          search: _songLyricsProvider.search,
          prefix: CustomIconButton(
            onPressed: () => setState(() {
              _songLyricsProvider.search('');
              _searching = false;
            }),
            icon: Icon(Icons.arrow_back),
          ),
          suffix: CustomIconButton(
            onPressed: () => _songLyricsProvider.tagsProvider.showFilters(context),
            icon: Icon(Icons.filter_list),
          ),
        )
      : Text('Písně s hvězdičkou');

  Widget _trailing(BuildContext context) => _searching
      ? Container(width: 0)
      : IconButton(onPressed: () => setState(() => _searching = true), icon: Icon(Icons.search));

  Widget _body(BuildContext context) => SafeArea(
        child: _songLyricsProvider.songLyrics.isEmpty
            ? Container(
                padding: EdgeInsets.all(kDefaultPadding),
                child: Center(
                  child: Text(
                    'Nemáte vybrané žádné oblíbené písně. Píseň si můžete přidat do oblíbených v${unbreakableSpace}náhledu písně.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.only(top: kDefaultPadding / 2),
                child: ChangeNotifierProvider.value(
                  value: _songLyricsProvider,
                  child: Scrollbar(
                    child: Consumer<SongLyricsProvider>(
                      builder: (context, provider, child) => ReorderableList(
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
                        child: ListView.builder(
                          itemBuilder: (context, index) => ReorderableRow(
                            key: provider.songLyrics[index].key,
                            child: SongLyricRow(songLyric: provider.songLyrics[index], showStar: false),
                          ),
                          itemCount: provider.songLyrics.length,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      );
}
