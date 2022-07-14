import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook_record.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/routes/arguments/search.dart';

class SongLyricTag extends StatelessWidget {
  final SongbookRecord? songbookRecord;
  final Tag? tag;

  const SongLyricTag({Key? key, this.songbookRecord, this.tag})
      : assert(songbookRecord != null || tag != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String text;
    if (songbookRecord != null) {
      text = songbookRecord!.songbook.target!.name;
    } else {
      text = tag!.name;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
      ),
      clipBehavior: Clip.antiAlias,
      child: Highlightable(
        highlightBackground: true,
        color: theme.colorScheme.primary.withAlpha(0x20),
        highlightColor: theme.colorScheme.primary.withAlpha(0x40),
        onTap: () => songbookRecord != null
            ? Navigator.of(context).popAndPushNamed('/songbook', arguments: songbookRecord!.songbook.target)
            : Navigator.of(context).popAndPushNamed('/search', arguments: SearchScreenArguments(initialTag: tag)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2)
                  .copyWith(right: songbookRecord == null ? kDefaultPadding : kDefaultPadding / 2),
              child: Text(text),
            ),
            if (songbookRecord != null)
              Container(
                padding: const EdgeInsets.all(kDefaultPadding / 2).copyWith(right: 3 * kDefaultPadding / 4),
                color: theme.colorScheme.primary.withAlpha(0x30),
                child: Text(songbookRecord!.number),
              ),
          ],
        ),
      ),
    );
  }
}
