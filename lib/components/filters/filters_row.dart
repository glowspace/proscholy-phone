import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/components/filters/filter_tag.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/components/filters/filters.dart';

const double _addFilterRadius = 10;

class FiltersRow extends StatelessWidget {
  const FiltersRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selectedTags = context.select<AllSongLyricsProvider, List<Tag>>((provider) => provider.selectedTags);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.filter_alt),
        const SizedBox(width: kDefaultPadding / 2),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              ...selectedTags.map((tag) => FilterTag(tag: tag, isRemovable: true)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
                padding: const EdgeInsets.only(right: kDefaultPadding),
                child: DottedBorder(
                  dashPattern: const [7, 3],
                  color: theme.hintColor,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(_addFilterRadius),
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_addFilterRadius),
                    child: Highlightable(
                      padding: const EdgeInsets.all(kDefaultPadding / 2),
                      highlightBackground: true,
                      onTap: () => _showFilters(context),
                      child: Row(children: [
                        Icon(Icons.add, size: 12, color: theme.hintColor),
                        const SizedBox(width: kDefaultPadding / 4),
                        Text('Přidat filtr', style: theme.textTheme.caption),
                      ]),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  void _showFilters(BuildContext context) {
    final songLyricsProvider = context.read<AllSongLyricsProvider>();

    FocusScope.of(context).unfocus();

    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
      builder: (context) => SizedBox(
        height: 2 / 3 * MediaQuery.of(context).size.height,
        child: ChangeNotifierProvider.value(
          value: songLyricsProvider,
          builder: (_, __) => FiltersWidget(tagsSections: songLyricsProvider.tagsSections),
        ),
      ),
      useRootNavigator: true,
    );
  }
}
