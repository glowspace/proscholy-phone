import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/entities/songbook.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/components/search_widget.dart';
import 'package:zpevnik/screens/components/song_lyrics_list.dart';
import 'package:zpevnik/utils/platform.dart';

class SongbookScreen extends StatelessWidget with PlatformWidgetMixin {
  final Songbook songbook;

  final SongLyricsProvider _songLyricsProvider = SongLyricsProvider(DataProvider.shared.songLyrics);

  SongbookScreen({Key key, this.songbook}) : super(key: key);

  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: _searchWidget(context),
        ),
        child: _body(context),
      );

  @override
  Widget androidWidget(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: _searchWidget(context),
        ),
        body: _body(context),
      );

  Widget _body(BuildContext context) => SafeArea(
        child: ChangeNotifierProvider.value(value: _songLyricsProvider, child: SongLyricsListView()),
      );

  Widget _searchWidget(BuildContext context) => SearchWidget(
        placeholder: 'Zadejte slovo nebo číslo',
        searchable: _songLyricsProvider,
        leading: Icon(Icons.search),
      );
}
