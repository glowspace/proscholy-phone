import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/songbooks_provider.dart';
import 'package:zpevnik/screens/songbooks/componenets/songbook_widget.dart';

const _maxWidgetSize = 250;

class SongbookListView extends StatelessWidget {
  const SongbookListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final count = (MediaQuery.of(context).size.width / _maxWidgetSize).ceil();

    return Scrollbar(
      child: Consumer<SongbooksProvider>(
        builder: (context, provider, _) => GridView.count(
          childAspectRatio: 1 / 1.2, // to fit multiline songbook names on small devices
          crossAxisCount: count,
          children: List.generate(
            provider.songbooks.length,
            (index) => SongbookWidget(songbook: provider.songbooks[index]),
          ),
        ),
      ),
    );
  }
}
