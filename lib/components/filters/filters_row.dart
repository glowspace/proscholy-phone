import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/components/filters/filter_tag.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/components/filters/filters.dart';
import 'package:zpevnik/utils/extensions.dart';

const double _addFilterRadius = 7;

class FiltersRow extends StatelessWidget {
  const FiltersRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selectedTags = context.watch<AllSongLyricsProvider>().selectedTags;

    final addFilterButtonColor = theme.brightness.isLight ? const Color(0xff848484) : const Color(0xff7b7b7b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.filter_alt, color: theme.brightness.isLight ? const Color(0xff50555c) : const Color(0xffafaaa3)),
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
                  color: addFilterButtonColor,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(_addFilterRadius),
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_addFilterRadius),
                    child: Highlightable(
                      padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPadding / 2,
                        horizontal: kDefaultPadding / 2,
                      ),
                      highlightBackground: true,
                      onTap: () => _showFilters(context),
                      child: Row(children: [
                        Icon(Icons.add, size: 12, color: addFilterButtonColor),
                        const SizedBox(width: kDefaultPadding / 4),
                        Text('Přidat filtr', style: theme.textTheme.labelMedium?.copyWith(color: addFilterButtonColor)),
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
