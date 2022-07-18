import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/playlist/playlist_row.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/components/songbook/songbook_row.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/extensions.dart';

const double _navigateNextIconSize = 20;

const _maxShowingPlaylists = 3;

class SongbooksSection extends StatelessWidget {
  const SongbooksSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final songbooks = dataProvider.songbooks;

    return Section(
      title: Text('Zpěvníky', style: Theme.of(context).textTheme.titleLarge),
      child: ListView.separated(
        itemCount: min(_maxShowingPlaylists, songbooks.length),
        itemBuilder: (_, index) => SongbookRow(songbook: songbooks[index]),
        separatorBuilder: (_, __) => const Divider(height: 0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
      action: Highlightable(
        onTap: () => NavigationProvider.navigatorOf(context).pushNamed('/songbooks'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Všechny zpěvníky',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).brightness.isLight ? lightTextColor : darkTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.navigate_next, size: _navigateNextIconSize),
          ],
        ),
      ),
    );
  }
}
