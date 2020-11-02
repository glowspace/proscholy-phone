import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/providers/selection_provider.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/components/custom_icon_button.dart';
import 'package:zpevnik/screens/components/search_widget.dart';
import 'package:zpevnik/screens/components/song_lyrics_list.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoriteScreenState(
      SongLyricsProvider(DataProvider.shared.songLyrics.where((songLyric) => songLyric.isFavorite).toList()));
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
          placeholder: 'Zadejte slovo nebo číslo',
          search: _songLyricsProvider.search,
          leading: CustomIconButton(
            onPressed: () => setState(() {
              _songLyricsProvider.search('');
              _searching = false;
            }),
            icon: Icon(Icons.arrow_back),
          ),
          trailing: CustomIconButton(
            onPressed: null,
            icon: Icon(Icons.filter_list),
          ),
        )
      : Text('Písně s hvězdičkou');

  Widget _trailing(BuildContext context) => _searching
      ? Container(width: 0)
      : IconButton(
          onPressed: () => setState(() => _searching = true),
          icon: Icon(Icons.search),
        );

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
            : ChangeNotifierProvider(
                create: (_) => SelectionProvider(),
                child: ChangeNotifierProvider.value(value: _songLyricsProvider, child: SongLyricsListView()),
              ),
      );
}
