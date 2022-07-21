import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/filters/filters.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/utils/extensions.dart';

const double _addFilterRadius = 7;

class AddFilterTag extends StatelessWidget {
  const AddFilterTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final addFilterButtonColor = theme.brightness.isLight ? const Color(0xff848484) : const Color(0xff7b7b7b);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4, vertical: 2),
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
              vertical: kDefaultPadding / 3,
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
    );
  }
}
