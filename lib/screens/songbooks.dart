import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/songbooks.dart';
import 'package:zpevnik/screens/components/songbooks_grid_view.dart';

class SongbooksScreen extends StatelessWidget {
  const SongbooksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<DataProvider, SongbooksProvider>(
      create: (_) => SongbooksProvider(),
      update: (_, dataProvider, songbooksProvider) => songbooksProvider!..update(dataProvider),
      builder: (_, __) => const SongbooksGridView(key: PageStorageKey('songbooks')),
    );
  }
}
