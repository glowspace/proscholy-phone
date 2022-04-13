import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/screens/components/highlightable.dart';
import 'package:zpevnik/theme.dart';

class FilterTag extends StatelessWidget {
  final Tag tag;
  final bool isPartOfActiveTags;

  const FilterTag({Key? key, required this.tag, this.isPartOfActiveTags = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final textStyle = appTheme.bodyTextStyle?.copyWith(color: appTheme.filtersTextColor);

    final provider = context.watch<SongLyricsProvider>();

    return GestureDetector(
      onTap: () => provider.toggleSelectedTag(tag),
      child: Container(
        decoration: BoxDecoration(
          color: (tag.isSelected && !isPartOfActiveTags) ? _selectedColor(tag) : Colors.transparent,
          border: Border.all(color: appTheme.borderColor),
          borderRadius: BorderRadius.circular(100),
        ),
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tag.name, style: textStyle),
            if (isPartOfActiveTags)
              Highlightable(
                padding: EdgeInsets.only(left: kDefaultPadding / 2),
                child: Icon(Icons.close, size: 14),
                onPressed: () => provider.toggleSelectedTag(tag),
              ),
          ],
        ),
      ),
    );
  }

  Color _selectedColor(Tag tag) {
    switch (tag.type) {
      case TagType.liturgyPart:
        return blue;
      case TagType.liturgyPeriod:
        return red;
      case TagType.saints:
      case TagType.generic:
      case TagType.sacredOccasion:
        return green;
      case TagType.language:
        return red;
      default:
        return Colors.transparent;
    }
  }
}
