import 'package:flutter/material.dart';
import 'package:zpevnik/components/songbook/songbook_row.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook.dart';

class SongbooksListView extends StatelessWidget {
  final List<Songbook> songbooks;
  final bool shrinkWrap;

  const SongbooksListView({super.key, required this.songbooks, this.shrinkWrap = false});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ListView.separated(
        primary: false,
        padding: shrinkWrap ? null : const EdgeInsets.only(top: kDefaultPadding / 2, bottom: 2 * kDefaultPadding),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: songbooks.length,
        itemBuilder: (_, index) => SongbookRow(songbook: songbooks[index]),
        separatorBuilder: (_, __) => const Divider(height: 0),
        shrinkWrap: shrinkWrap,
        physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      ),
    );
  }
}
