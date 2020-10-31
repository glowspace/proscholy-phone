import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/providers/songbooks_provider.dart';
import 'package:zpevnik/screens/components/custom_icon_button.dart';
import 'package:zpevnik/screens/components/songbooks_list.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';
import 'package:zpevnik/screens/components/search_widget.dart';

class SongbooksScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SongbooksScreenState();
}

class _SongbooksScreenState extends State<SongbooksScreen> with PlatformStateMixin {
  final SongbooksProvider _songbooksProvider = SongbooksProvider(DataProvider.shared.songbooks);

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
        child: ChangeNotifierProvider.value(value: _songbooksProvider, child: SongbookListView()),
      );

  Widget _searchWidget(BuildContext context) => SearchWidget(
        placeholder: 'Zadejte název nebo zkratku zpěvníku',
        search: _songbooksProvider.search,
        leading: CustomIconButton(
          onPressed: null,
          icon: Icon(Icons.search, color: AppTheme.shared.searchFieldIconColor(context)),
        ),
      );
}
