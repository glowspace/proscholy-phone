import 'package:flutter/material.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/bible_verse.dart';
import 'package:proscholy_common/models/custom_text.dart';
import 'package:proscholy_common/models/model.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/songbook.dart';
import 'package:proscholy_common/routing/arguments.dart';
import 'package:proscholy_common/utils/extensions.dart';

class RecentItemRow extends StatelessWidget {
  final RecentItem recentItem;

  const RecentItemRow({super.key, required this.recentItem});

  @override
  Widget build(BuildContext context) {
    return HighlightableWidget(
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
            child: Text(recentItem.displayName),
          ),
        ),
      ]),
    );
  }

  void _push(BuildContext context) {
    switch (recentItem.recentItemType) {
      case RecentItemType.bibleVerse:
        context.push('/display', arguments: DisplayScreenArguments.bibleVerse(recentItem as BibleVerse));
        break;
      case RecentItemType.customText:
        context.push('/display', arguments: DisplayScreenArguments.customText(recentItem as CustomText));
        break;
      case RecentItemType.playlist:
        context.push('/playlist', arguments: recentItem as Playlist);
        break;
      case RecentItemType.songbook:
        context.push('/songbook', arguments: recentItem as Songbook);
        break;
      case RecentItemType.songLyric:
        context.push('/display', arguments: DisplayScreenArguments.songLyric(recentItem as SongLyric));
        break;
    }
  }
}
