import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/songbooks_provider.dart';
import 'package:zpevnik/screens/songbooks/componenets/songbook_widget.dart';

class SongbookListView extends StatelessWidget {
  const SongbookListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scrollbar(
        child: Consumer<SongbooksProvider>(
          builder: (context, provider, _) => GridView.count(
            childAspectRatio: 4 / 4.5,
            crossAxisCount: 2,
            children: List.generate(
              provider.songbooks.length,
              (index) => SongbookWidget(songbook: provider.songbooks[index]),
            ),
          ),
        ),
      );
}
