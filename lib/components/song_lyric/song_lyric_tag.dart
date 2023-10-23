import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook_record.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/tags.dart';
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

    final backgroundColor = theme.colorScheme.secondaryContainer;
    final numberBackgroundColor = theme.colorScheme.primaryContainer;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: theme.hintColor, width: 0.5),
      ),
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(32),
        color: backgroundColor,
        child: Highlightable(
          highlightBackground: true,
          borderRadius: BorderRadius.circular(32),
          highlightColor: theme.colorScheme.primary.withAlpha(0x20),
          onTap: () => songbookRecord != null
              ? _pushSearch(context, songbookRecord!.songbook.target!.tag)
              : _pushSearch(context, tag!),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2)
                    .copyWith(
                        right: songbookRecord == null || songbookRecord!.number.isEmpty
                            ? kDefaultPadding
                            : kDefaultPadding / 2),
                child: Text(text),
              ),
              if (songbookRecord != null && songbookRecord!.number.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(kDefaultPadding / 2).copyWith(right: 3 * kDefaultPadding / 4),
                  color: numberBackgroundColor,
                  child: Text(songbookRecord!.number),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _pushSearch(BuildContext context, Tag tag) {
    context.providers.read(selectedTagsProvider.notifier).push(initialTag: tag);
    context.popAndPush('/search', arguments: tag);
  }
}
