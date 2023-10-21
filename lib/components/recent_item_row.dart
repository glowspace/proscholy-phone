import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/routing/arguments.dart';
import 'package:zpevnik/utils/extensions.dart';

class RecentItemRow extends StatelessWidget {
  final RecentItem recentItem;

  const RecentItemRow({super.key, required this.recentItem});

  @override
  Widget build(BuildContext context) {
    return Highlightable(
      highlightBackground: true,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 3),
      onTap: () => _push(context),
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Icon(switch (recentItem.recentItemType) {
            RecentItemType.bibleVerse => Icons.book_outlined,
            RecentItemType.customText => Icons.edit_note,
            RecentItemType.playlist => Icons.playlist_play_rounded,
            RecentItemType.songbook => Icons.book,
            RecentItemType.songLyric => Icons.music_note,
          }),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 2),
            child: Text(recentItem.name),
          ),
        ),
      ]),
    );
  }

  void _push(BuildContext context) {
    switch (recentItem.recentItemType) {
      case RecentItemType.bibleVerse:
      case RecentItemType.customText:
      case RecentItemType.songLyric:
        context.push('/display', arguments: DisplayScreenArguments.item(recentItem));
        break;
      case RecentItemType.playlist:
        context.push('/playlist', arguments: recentItem as Playlist);
        break;
      case RecentItemType.songbook:
        context.push('/songbook', arguments: recentItem as Songbook);
        break;
    }
  }
}
