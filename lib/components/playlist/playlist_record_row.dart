import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/selected_displayable_item_index.dart';
import 'package:zpevnik/components/selected_row_highlight.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist_record.dart';
import 'package:zpevnik/providers/bible_verse.dart';
import 'package:zpevnik/providers/custom_text.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/routing/arguments.dart';
import 'package:zpevnik/utils/extensions.dart';

class PlaylistRecordRow extends ConsumerWidget {
  final PlaylistRecord playlistRecord;
  final DisplayScreenArguments displayScreenArguments;

  const PlaylistRecordRow({super.key, required this.playlistRecord, required this.displayScreenArguments});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    const textMargin = EdgeInsets.only(top: 2);

    final bibleVerse = ref.watch(bibleVerseProvider(playlistRecord.bibleVerse.targetId));
    final customText = ref.watch(customTextProvider(playlistRecord.customText.targetId));
    final songLyric = ref.watch(songLyricProvider(playlistRecord.songLyric.targetId));

    final String title;
    final IconData? icon;
    if (bibleVerse != null) {
      title = bibleVerse.name;
      icon = Icons.book_outlined;
    } else if (customText != null) {
      title = customText.name;
      icon = Icons.edit_note;
    } else if (songLyric != null) {
      title = songLyric.name;
      icon = null;
    } else {
      throw UnsupportedError('unsupported playlist record');
    }

    return Highlightable(
      highlightBackground: true,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
      onTap: () => _pushPlaylistRecord(context),
      child: SelectedRowHighlight(
        selectedObjectNotifier: SelectedDisplayableItemArguments.of(context),
        object: bibleVerse ?? customText ?? songLyric,
        mapSelectedObject: (arguments) => arguments.items[arguments.initialIndex],
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
                  if (songLyric?.secondaryName1?.isNotEmpty ?? false)
                    Container(margin: textMargin, child: Text(songLyric!.secondaryName1!, style: textTheme.bodySmall)),
                  if (songLyric?.secondaryName2?.isNotEmpty ?? false)
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
    final selectedDisplayableItemArgumentsNotifier = SelectedDisplayableItemArguments.of(context);

    if (selectedDisplayableItemArgumentsNotifier != null) {
      selectedDisplayableItemArgumentsNotifier.value = displayScreenArguments;
    } else {
      context.push('/display', arguments: displayScreenArguments);
    }
  }
}
