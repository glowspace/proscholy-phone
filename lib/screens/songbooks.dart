import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/songbooks.dart';
import 'package:zpevnik/screens/components/searchable_list_view.dart';
import 'package:zpevnik/screens/components/songbook_tile.dart';
import 'package:zpevnik/screens/utils/updateable.dart';

class SongbooksScreen extends StatefulWidget {
  const SongbooksScreen({Key? key}) : super(key: key);

  @override
  _SongbooksScreenState createState() => _SongbooksScreenState();
}

class _SongbooksScreenState extends State<SongbooksScreen> with Updateable {
  late SongbooksProvider _songbooksProvider;

  @override
  void initState() {
    super.initState();

    _songbooksProvider = SongbooksProvider(context.read<DataProvider>().songbooks);
  }

  @override
  Widget build(BuildContext context) {
    final itemBuilder = (songbook) => SongbookTile(songbook: songbook);

    return ChangeNotifierProvider.value(
      value: _songbooksProvider,
      builder: (_, __) => SearchableListView(
        key: PageStorageKey('songbooks'),
        itemsProvider: _songbooksProvider,
        itemBuilder: itemBuilder,
        searchPlaceholder: 'Zadejte název nebo zkratku zpěvníku',
        crossAxisCount: 2,
      ),
    );
  }

  @override
  void update() {
    super.update();

    _songbooksProvider = SongbooksProvider(context.read<DataProvider>().songbooks);
  }

  @override
  List<Listenable> get listenables => [context.read<DataProvider>()];
}
