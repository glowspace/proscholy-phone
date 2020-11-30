import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/providers/songbooks_provider.dart';
import 'package:zpevnik/screens/components/highlightable_button.dart';
import 'package:zpevnik/screens/songbooks/componenets/songbooks_list.dart';
import 'package:zpevnik/status_bar_wrapper.dart';
import 'package:zpevnik/utils/platform.dart';
import 'package:zpevnik/screens/components/search_widget.dart';

class SongbooksScreen extends StatefulWidget {
  const SongbooksScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongbooksScreenState();
}

class _SongbooksScreenState extends State<SongbooksScreen> with PlatformStateMixin {
  final searchFieldFocusNode = FocusNode();

  SongbooksProvider _songbooksProvider;

  @override
  void initState() {
    super.initState();

    // fixme: there might be better way to persist this, but I don't know it yet
    _songbooksProvider = PageStorage.of(context)?.readState(context) as SongbooksProvider ??
        SongbooksProvider(DataProvider.shared.songbooks);

    PageStorage.of(context)?.writeState(context, _songbooksProvider);
  }

  @override
  Widget iOSWidget(BuildContext context) => StatusBarWrapper(child: CupertinoPageScaffold(child: _body(context)));

  @override
  Widget androidWidget(BuildContext context) => StatusBarWrapper(child: Scaffold(body: _body(context)));

  Widget _body(BuildContext context) => SafeArea(
        child: Column(children: [
          Container(
            padding: EdgeInsets.fromLTRB(kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
            child: _searchWidget(context),
          ),
          Expanded(
            child: ChangeNotifierProvider.value(
              value: _songbooksProvider,
              child: SongbookListView(key: PageStorageKey('songbooks_grid_view')),
            ),
          ),
        ]),
      );

  Widget _searchWidget(BuildContext context) => SearchWidget(
        key: PageStorageKey('songbooks_search_widget'),
        placeholder: 'Zadejte název nebo zkratku zpěvníku',
        focusNode: searchFieldFocusNode,
        search: _songbooksProvider.search,
        prefix: HighlightableButton(
          icon: Icon(Icons.search),
          onPressed: () => FocusScope.of(context).requestFocus(searchFieldFocusNode),
        ),
      );
}
