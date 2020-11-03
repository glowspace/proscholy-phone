import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/bottom_sheets.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/providers/selection_provider.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/components/custom_icon_button.dart';
import 'package:zpevnik/screens/components/song_lyrics_list.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';
import 'package:zpevnik/screens/components/search_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with PlatformStateMixin {
  final SongLyricsProvider _songLyricsProvider =
      SongLyricsProvider(DataProvider.shared.songLyrics, selectionProvider: SelectionProvider());

  @override
  void initState() {
    super.initState();

    _songLyricsProvider.selectionProvider.addListener(_update);
  }

  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: _leading(context),
          middle: _middle(context),
          trailing: _songLyricsProvider.selectionProvider.selectionEnabled ? Row(children: _trailing(context)) : null,
        ),
        child: _body(context),
      );

  @override
  Widget androidWidget(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: _leading(context),
          title: _middle(context),
          actions: _songLyricsProvider.selectionProvider.selectionEnabled ? _trailing(context) : null,
        ),
        body: _body(context),
      );

  Widget _body(BuildContext context) => SafeArea(
        child: ChangeNotifierProvider.value(
          value: _songLyricsProvider,
          child: SongLyricsListView(),
        ),
      );

  List<Widget> _trailing(BuildContext context) => [
        IconButton(
          onPressed: _songLyricsProvider.selectionProvider.selectedCount > 0
              ? () => _songLyricsProvider.selectionProvider.toggleFavorite()
              : null,
          color: AppTheme.shared.selectedRowColor(context),
          icon: Icon(_songLyricsProvider.selectionProvider.allFavorited ? Icons.star : Icons.star_outline),
        ),
        IconButton(
          onPressed: null,
          color: AppTheme.shared.selectedRowColor(context),
          icon: Icon(Icons.playlist_add),
        ),
        IconButton(
          onPressed: () => _songLyricsProvider.selectionProvider.toggleAll(_songLyricsProvider.songLyrics),
          color: AppTheme.shared.selectedRowColor(context),
          icon: Icon(Icons.select_all),
        )
      ];

  Widget _leading(BuildContext context) => _songLyricsProvider.selectionProvider.selectionEnabled
      ? IconButton(
          onPressed: () => setState(() => _songLyricsProvider.selectionProvider.selectionEnabled = false),
          icon: Icon(Icons.close, color: AppTheme.shared.selectedRowColor(context)),
        )
      : null;

  Widget _middle(BuildContext context) =>
      _songLyricsProvider.selectionProvider.selectionEnabled ? _title(context) : _searchWidget(context);

  Widget _title(BuildContext context) {
    String title;

    if (_songLyricsProvider.selectionProvider.selectedCount == 0)
      title = "Nic nevybráno";
    else if (_songLyricsProvider.selectionProvider.selectedCount == 1)
      title = "1 píseň";
    else if (_songLyricsProvider.selectionProvider.selectedCount < 5)
      title = "${_songLyricsProvider.selectionProvider.selectedCount} písně";
    else
      title = "${_songLyricsProvider.selectionProvider.selectedCount} písní";

    return FittedBox(fit: BoxFit.scaleDown, child: Text(title));
  }

  Widget _searchWidget(BuildContext context) => SearchWidget(
        placeholder: 'Zadejte slovo nebo číslo',
        initial: _songLyricsProvider.searchText,
        search: _songLyricsProvider.search,
        leading: CustomIconButton(
          onPressed: null,
          icon: Icon(Icons.search, color: AppTheme.shared.searchFieldIconColor(context)),
        ),
        trailing: CustomIconButton(
          onPressed: () => showFilters(context, _songLyricsProvider.tagsProvider),
          icon: Icon(Icons.filter_list, color: AppTheme.shared.searchFieldIconColor(context)),
        ),
      );

  void _update() => setState(() => {});

  @override
  void dispose() {
    _songLyricsProvider.selectionProvider.removeListener(_update);

    super.dispose();
  }
}
