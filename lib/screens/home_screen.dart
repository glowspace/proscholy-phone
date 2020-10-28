import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/components/song_lyrics_list.dart';
import 'package:zpevnik/utils/platform_state.dart';
import 'package:zpevnik/screens/components/search_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with PlatformStateMixin {
  final SongLyricsProvider _songLyricsProvider =
      SongLyricsProvider(DataProvider.shared.songLyrics);

  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: _searchWidget(context),
          transitionBetweenRoutes: false,
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
        child: ChangeNotifierProvider.value(
            value: _songLyricsProvider, child: SongLyricsListView()),
      );

  Widget _searchWidget(BuildContext context) => SearchWidget(
        placeholder: 'Zadejte slovo nebo číslo',
        searchable: _songLyricsProvider,
        leading: Icon(Icons.search),
        trailing: GestureDetector(
          onTap: () => _showFilters(context),
          child: Icon(Icons.filter_list),
        ),
      );

  void _showFilters(BuildContext context) => showCupertinoModalBottomSheet(
        context: context,
        builder: (context, scrollController) => SizedBox(
          height: 400,
          child: Container(
            color: Colors.red,
          ),
        ),
      );
}
