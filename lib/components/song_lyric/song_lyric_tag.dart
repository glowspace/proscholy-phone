import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook_record.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/routes/arguments/search.dart';
import 'package:zpevnik/utils/extensions.dart';

class SongLyricTag extends StatelessWidget {
  final SongbookRecord? songbookRecord;
  final Tag? tag;

  const SongLyricTag({super.key, this.songbookRecord, this.tag}) : assert(songbookRecord != null || tag != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String text;
    if (songbookRecord != null) {
      text = songbookRecord!.songbook.target!.name;
    } else {
      text = tag!.name;
    }

    final backgroundColor = theme.brightness.isLight ? const Color(0xfff2f1f6) : const Color(0xff15131d);
    final numberBackgroundColor = theme.brightness.isLight ? const Color(0xffe9e4f5) : const Color(0xff1c1333);

    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(32),
      color: backgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        highlightColor: theme.colorScheme.primary.withAlpha(0x20),
        onTap: () => songbookRecord != null
            ? Navigator.of(context).popAndPushNamed(
                '/search',
                // arguments: SearchScreenArguments(
                //   initialTag: context.read<DataProvider>().getTagBySongbookName(songbookRecord!.songbook.target!.name),
                // ),
              )
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
                color: numberBackgroundColor,
                child: Text(songbookRecord!.number),
              ),
          ],
        ),
      ),
    );
  }
}
