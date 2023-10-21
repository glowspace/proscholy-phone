import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/playlist/selected_playlist_record.dart';
import 'package:zpevnik/components/selected_row_highlight.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist_record.dart';
import 'package:zpevnik/routing/arguments.dart';
import 'package:zpevnik/utils/extensions.dart';

class PlaylistRecordRow extends StatelessWidget {
  final PlaylistRecord playlistRecord;
  final DisplayScreenArguments displayScreenArguments;

  const PlaylistRecordRow({super.key, required this.playlistRecord, required this.displayScreenArguments});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    const textMargin = EdgeInsets.only(top: 2);

    final songLyric = playlistRecord.songLyric.target;
    final bibleVerse = playlistRecord.bibleVerse.target;
    final customText = playlistRecord.customText.target;

    final String title;
    final IconData? icon;
    if (songLyric != null) {
      title = songLyric.name;
      icon = null;
    } else if (bibleVerse != null) {
      title = bibleVerse.name;
      icon = Icons.book_outlined;
    } else if (customText != null) {
      title = customText.name;
      icon = Icons.edit_note;
    } else {
      throw UnimplementedError('unsupported playlist record');
    }

    return Highlightable(
      highlightBackground: true,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 3),
      onTap: () => _pushPlaylistRecord(context),
      child: SelectedRowHighlight(
        selectedObjectNotifier: SelectedPlaylistRecord.of(context),
        object: playlistRecord,
        child: Row(children: [
          const ReorderableDragStartListener(
            index: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                1.5 * kDefaultPadding,
                kDefaultPadding / 2,
                kDefaultPadding,
                kDefaultPadding / 2,
              ),
              child: Icon(Icons.drag_indicator),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.bodyMedium),
                  if (songLyric?.secondaryName1 != null)
                    Container(margin: textMargin, child: Text(songLyric!.secondaryName1!, style: textTheme.bodySmall)),
                  if (songLyric?.secondaryName2 != null)
                    Container(margin: textMargin, child: Text(songLyric!.secondaryName2!, style: textTheme.bodySmall)),
                ],
              ),
            ),
          ),
          if (icon != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
              child: Icon(icon),
            ),
        ]),
      ),
    );
  }

  void _pushPlaylistRecord(BuildContext context) {
    final selectedPlaylistRecordNotifier = SelectedPlaylistRecord.of(context);

    if (selectedPlaylistRecordNotifier != null) {
      selectedPlaylistRecordNotifier.value = playlistRecord;
    } else {
      context.push('/display', arguments: displayScreenArguments);
    }
  }
}
