import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zpevnik/components/songbook/songbook_tile.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook.dart';

const _minTileWidth = 250;

class SongbooksGridView extends StatelessWidget {
  final List<Songbook> songbooks;
  final bool shrinkWrap;
  final bool isCrossAxisCountMultipleOfTwo;

  const SongbooksGridView({
    super.key,
    required this.songbooks,
    this.shrinkWrap = false,
    this.isCrossAxisCountMultipleOfTwo = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = max(2, (width / _minTileWidth).floor());

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
