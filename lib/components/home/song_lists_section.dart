import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/playlist/playlist_row.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/extensions.dart';

const double _navigateNextIconSize = 20;

const _maxShowingPlaylists = 3;

class SongListsSection extends StatelessWidget {
  const SongListsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final playlists = [dataProvider.favorites] + dataProvider.playlists;

    return Section(
      title: Text('Moje seznamy', style: Theme.of(context).textTheme.titleLarge),
      action: Highlightable(
        onTap: () => Navigator.of(context).pushNamed('/playlists'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Všechny seznamy',
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
      child: ListView.separated(
        itemCount: min(_maxShowingPlaylists, playlists.length),
        itemBuilder: (_, index) => PlaylistRow(playlist: playlists[index], visualDensity: VisualDensity.comfortable),
        separatorBuilder: (_, __) => const Divider(height: 0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
