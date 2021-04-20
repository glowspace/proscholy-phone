import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/components/highlightable_button.dart';
import 'package:zpevnik/screens/components/search_widget.dart';
import 'package:zpevnik/screens/components/song_lyrics_list.dart';
import 'package:zpevnik/screens/song_lyric/song_lyric_screen.dart';
import 'package:zpevnik/status_bar_wrapper.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/platform/mixin.dart';

class PlaylistScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistScreen({Key key, this.playlist}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlaylistScreenState(SongLyricsProvider(playlist.songLyrics));
}

class _PlaylistScreenState extends State<PlaylistScreen> with PlatformStateMixin {
  final SongLyricsProvider _songLyricsProvider;

  final _searchFieldFocusNode = FocusNode();

  bool _searching;

  _PlaylistScreenState(this._songLyricsProvider);

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
          transitionBetweenRoutes: false, // needed because of search widget
        ),
        child: _body(context),
      );

  @override
  Widget androidWidget(BuildContext context) => StatusBarWrapper(
        child: Scaffold(
          appBar: AppBar(
            leading: _leading(context),
            title: _middle(context),
            titleSpacing: kDefaultPadding,
            actions: [_trailing(context)],
            leadingWidth: _searching ? 0 : null,
            shadowColor: AppTheme.of(context).appBarDividerColor,
          ),
          body: _body(context),
        ),
      );

  Widget _leading(BuildContext context) => _searching ? Container(width: 0) : null;

  Widget _middle(BuildContext context) => _searching
      ? SearchWidget(
          key: PageStorageKey('playlist_search_widget'),
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
      : Text(widget.playlist.name, style: AppTheme.of(context).navBarTitleTextStyle);

  Widget _trailing(BuildContext context) => _searching
      ? Container(width: 0)
      : HighlightableButton(
          icon: Icon(Icons.search),
          onPressed: () => setState(() {
            _searchFieldFocusNode.requestFocus();
            _searching = true;
          }),
        );

  Widget _body(BuildContext context) => SafeArea(
        child: ChangeNotifierProvider.value(
            value: _songLyricsProvider,
            child: SongLyricsListView(
              placeholder:
                  'V tomto seznamu nemáte vybranou žádnou píseň. Píseň si můžete přidat do oblíbených v${unbreakableSpace}náhledu písně.',
            )),
      );

  void _pushSelectedSongLyric(BuildContext context) {
    if (_songLyricsProvider.matchedById == null) return;

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SongLyricScreen(songLyric: _songLyricsProvider.matchedById)));
  }
}
