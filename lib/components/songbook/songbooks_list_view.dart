import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/songbook/songbook_row.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';

class SongbooksListView extends StatelessWidget {
  const SongbooksListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songbooks = context.watch<DataProvider>().songbooks;

    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ListView.builder(
        primary: false,
        padding: const EdgeInsets.only(top: kDefaultPadding / 2, bottom: 2 * kDefaultPadding),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: songbooks.length,
        itemBuilder: (context, index) => SongbookRow(songbook: songbooks[index]),
      ),
    );
  }
}
