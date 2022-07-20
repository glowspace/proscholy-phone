import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zpevnik/components/songbook/songbook_row.dart';
import 'package:zpevnik/components/songbook/songbook_tile.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/utils/extensions.dart';

const _minTileWidth = 250;

class SongbooksListView extends StatelessWidget {
  final List<Songbook> songbooks;
  final bool shrinkWrap;
  final bool isCrossAxisCountMultipleOfTwo;

  const SongbooksListView({
    Key? key,
    required this.songbooks,
    this.shrinkWrap = false,
    this.isCrossAxisCountMultipleOfTwo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).isTablet) {
      return _SongbooksListViewTablet(
        songbooks: songbooks,
        shrinkWrap: shrinkWrap,
        isCrossAxisCountMultipleOfTwo: isCrossAxisCountMultipleOfTwo,
      );
    }

    return _SongbooksListViewPhone(songbooks: songbooks, shrinkWrap: shrinkWrap);
  }
}

class _SongbooksListViewPhone extends StatelessWidget {
  final List<Songbook> songbooks;
  final bool shrinkWrap;

  const _SongbooksListViewPhone({Key? key, required this.songbooks, required this.shrinkWrap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ListView.builder(
        primary: false,
        padding: shrinkWrap ? null : const EdgeInsets.only(top: kDefaultPadding / 2, bottom: 2 * kDefaultPadding),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: songbooks.length,
        itemBuilder: (context, index) => SongbookRow(songbook: songbooks[index]),
        shrinkWrap: shrinkWrap,
        physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      ),
    );
  }
}

class _SongbooksListViewTablet extends StatelessWidget {
  final List<Songbook> songbooks;
  final bool shrinkWrap;
  final bool isCrossAxisCountMultipleOfTwo;

  const _SongbooksListViewTablet({
    Key? key,
    required this.songbooks,
    required this.shrinkWrap,
    required this.isCrossAxisCountMultipleOfTwo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = (width / _minTileWidth).floor();

    if (isCrossAxisCountMultipleOfTwo && crossAxisCount % 2 != 0) crossAxisCount--;

    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: AlignedGridView.count(
        crossAxisCount: crossAxisCount,
        primary: false,
        padding: shrinkWrap ? null : const EdgeInsets.only(top: kDefaultPadding / 2, bottom: 2 * kDefaultPadding),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: songbooks.length,
        itemBuilder: (context, index) => SongbookTile(songbook: songbooks[index]),
        shrinkWrap: shrinkWrap,
        physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      ),
    );
  }
}
