import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/components/songbook/songbook_row.dart';
import 'package:zpevnik/components/songbook/songbook_tile.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/extensions.dart';

const double _navigateNextIconSize = 20;

const _maxShowingSongbooksPhone = 3;
const _maxShowingSongbooksTablet = 4;

class SongbooksSection extends StatelessWidget {
  const SongbooksSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      if (constraints.maxWidth > kTabletWidthBreakpoint) {
        return const _SongbooksSectionTablet();
      }

      return const _SongbooksSectionPhone();
    });
  }
}

class _SongbooksSectionPhone extends StatelessWidget {
  const _SongbooksSectionPhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final songbooks = dataProvider.songbooks;

    return Section(
      title: Text('Zpěvníky', style: Theme.of(context).textTheme.titleLarge),
      child: ListView.separated(
        itemCount: min(_maxShowingSongbooksPhone, songbooks.length),
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

class _SongbooksSectionTablet extends StatelessWidget {
  const _SongbooksSectionTablet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final songbooks = dataProvider.songbooks;

    return Section(
      title: Text('Zpěvníky', style: Theme.of(context).textTheme.titleLarge),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: songbooks
            .sublist(0, min(_maxShowingSongbooksTablet, songbooks.length))
            .map((songbook) => SongbookTile(songbook: songbook))
            .toList(),
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
