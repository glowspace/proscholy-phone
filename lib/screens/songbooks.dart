import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/songbooks.dart';
import 'package:zpevnik/screens/components/searchable_list_view.dart';
import 'package:zpevnik/screens/components/songbook_tile.dart';

class SongbooksScreen extends StatelessWidget {
  const SongbooksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<DataProvider, SongbooksProvider>(
      create: (_) => SongbooksProvider(),
      update: (_, dataProvider, songbooksProvider) => songbooksProvider!..update(dataProvider),
      builder: (_, __) => SearchableListView<Songbook, SongbooksProvider>(
        key: const PageStorageKey('songbooks'),
        itemBuilder: (songbook) => SongbookTile(songbook: songbook),
        searchPlaceholder: 'Zadejte název nebo zkratku zpěvníku',
        crossAxisCount: 2,
      ),
    );
  }
}
