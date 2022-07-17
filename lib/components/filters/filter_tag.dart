import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/utils/extensions.dart';

const double _filterRadius = 7;

class FilterTag extends StatelessWidget {
  final Tag tag;
  final bool isToggable;
  final bool isRemovable;

  const FilterTag({
    Key? key,
    required this.tag,
    this.isToggable = false,
    this.isRemovable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final padding = isRemovable
        ? const EdgeInsets.only(left: kDefaultPadding)
        : const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2);

    final songLyricsProvider = context.watch<AllSongLyricsProvider>();

    final backgroundColor = theme.brightness.isLight ? const Color(0xfff2f1f6) : const Color(0xff15131d);
    final selectedBackgroundColor = theme.brightness.isLight ? const Color(0xffe4e2ec) : const Color(0xff3c3653);
    final removeBackgroundColor = theme.brightness.isLight ? const Color(0xffe9e4f5) : const Color(0xff1c1333);

    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(tag.name),
        if (isRemovable) const SizedBox(width: kDefaultPadding / 2),
        if (isRemovable)
          Highlightable(
            highlightBackground: true,
            onTap: () => songLyricsProvider.toggleSelectedTag(tag),
            padding: const EdgeInsets.all(kDefaultPadding / 2).copyWith(left: kDefaultPadding / 4),
            color: removeBackgroundColor,
            highlightColor: theme.colorScheme.primary.withAlpha(0x10),
            child: const Icon(Icons.close, size: 14),
          ),
      ],
    );

    if (isToggable) {
      child = Highlightable(
        highlightBackground: true,
        highlightColor: theme.colorScheme.primary.withAlpha(0x10),
        onTap: () => songLyricsProvider.toggleSelectedTag(tag),
        padding: padding,
        child: child,
      );
    }

    return Container(
      margin: const EdgeInsets.all(kDefaultPadding / 4),
      padding: isToggable ? null : padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isRemovable ? _filterRadius : 32),
        border: isToggable ? Border.all(color: theme.hintColor, width: 0.5) : null,
        color: isRemovable ? backgroundColor : (songLyricsProvider.isSelected(tag) ? selectedBackgroundColor : null),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
