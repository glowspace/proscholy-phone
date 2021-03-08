import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/songbooks_provider.dart';
import 'package:zpevnik/screens/songbooks/componenets/songbook_widget.dart';

const _maxWidgetSize = 250;

class SongbookListView extends StatelessWidget {
  const SongbookListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final count = (MediaQuery.of(context).size.width / _maxWidgetSize).ceil();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: Scrollbar(
        child: Consumer<SongbooksProvider>(
          builder: (context, provider, _) => StaggeredGridView.countBuilder(
              crossAxisCount: count,
              itemCount: provider.songbooks.length,
              controller: provider.scrollController,
              itemBuilder: (context, index) => SongbookWidget(songbook: provider.songbooks[index]),
              staggeredTileBuilder: (index) => StaggeredTile.fit(1)),
        ),
      ),
    );
  }
}
