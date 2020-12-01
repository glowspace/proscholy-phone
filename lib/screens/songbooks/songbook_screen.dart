import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/components/highlightable_button.dart';
import 'package:zpevnik/screens/components/search_widget.dart';
import 'package:zpevnik/screens/components/song_lyrics_list.dart';
import 'package:zpevnik/screens/components/data_container.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/hex_color.dart';
import 'package:zpevnik/utils/platform.dart';

class SongbookScreen extends StatefulWidget {
  final Songbook songbook;

  const SongbookScreen({Key key, this.songbook}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongbookScreenState(SongLyricsProvider(songbook.songLyrics));
}

class _SongbookScreenState extends State<SongbookScreen> with PlatformStateMixin {
  final SongLyricsProvider _songLyricsProvider;

  bool _searching;

  _SongbookScreenState(this._songLyricsProvider);

  @override
  void initState() {
    super.initState();

    _searching = false;
  }

  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          actionsForegroundColor: _textColor,
          backgroundColor: (widget.songbook.color == null || !AppThemeNew.of(context).isLight)
              ? null
              : HexColor(widget.songbook.color),
          leading: _leading(context),
          middle: _middle(context),
          trailing: _trailing(context),
          transitionBetweenRoutes: false, // needed because of search widget
        ),
        child: _body(context),
      );

  @override
  Widget androidWidget(BuildContext context) => Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: _textColor),
          backgroundColor: (widget.songbook.color == null || !AppThemeNew.of(context).isLight)
              ? null
              : HexColor(widget.songbook.color),
          leading: _leading(context),
          title: _middle(context),
          titleSpacing: kDefaultPadding,
          actions: [_trailing(context)],
          leadingWidth: _searching ? 0 : null,
          shadowColor: AppTheme.shared.appBarDividerColor(context),
        ),
        body: _body(context),
      );

  Widget _leading(BuildContext context) => _searching ? Container(width: 0) : null;

  Widget _middle(BuildContext context) => _searching
      ? SearchWidget(
          key: PageStorageKey('songbook_search_widget'),
          placeholder: 'Zadejte slovo nebo číslo',
          search: _songLyricsProvider.search,
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
      : Text(widget.songbook.name, style: AppThemeNew.of(context).bodyTextStyle.copyWith(color: _textColor));

  Widget _trailing(BuildContext context) => _searching
      ? Container(width: 0)
      : HighlightableButton(
          icon: Icon(Icons.search),
          color: _textColor,
          highlightColor: AppThemeNew.of(context).highlightColor,
          onPressed: () => setState(() => _searching = true),
        );

  Widget _body(BuildContext context) => SafeArea(
        child: DataContainer(
          child: ChangeNotifierProvider.value(value: _songLyricsProvider, child: SongLyricsListView()),
          data: widget.songbook,
        ),
      );

  Color get _textColor => (widget.songbook.colorText == null || !AppThemeNew.of(context).isLight)
      ? null
      : HexColor(widget.songbook.colorText);
}
