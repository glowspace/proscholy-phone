import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook_record.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/tags.dart';
import 'package:zpevnik/routing/router.dart';
import 'package:zpevnik/utils/extensions.dart';

class SongLyricTag extends ConsumerWidget {
  final SongbookRecord? songbookRecord;
  final Tag? tag;

  const SongLyricTag({super.key, this.songbookRecord, this.tag}) : assert(songbookRecord != null || tag != null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      child: Highlightable(
        highlightBackground: true,
        borderRadius: BorderRadius.circular(32),
        highlightColor: theme.colorScheme.primary.withAlpha(0x20),
        onTap: () => songbookRecord != null
            ? _pushSearch(context, ref, songbookRecord!.songbook.target!.tag)
            : _pushSearch(context, ref, tag!),
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

  void _pushSearch(BuildContext context, WidgetRef ref, Tag tag) {
    ref.read(selectedTagsProvider.notifier).push(initialTag: tag);
    context.popAndPush('/search', arguments: tag);
  }
}
