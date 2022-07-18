import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/filters/add_filter_tag.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/components/filters/filter_tag.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/utils/extensions.dart';

class FiltersRow extends StatelessWidget {
  const FiltersRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selectedTags = context.watch<AllSongLyricsProvider>().selectedTags;

    final width = MediaQuery.of(context).size.width;

    if (selectedTags.isEmpty && width > kThreeSectionsWidthBreakpoint) return Container();

    return Container(
      margin: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.filter_alt, color: theme.brightness.isLight ? const Color(0xff50555c) : const Color(0xffafaaa3)),
          const SizedBox(width: kDefaultPadding / 2),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                ...selectedTags.map((tag) => FilterTag(tag: tag, isRemovable: true)),
                if (width <= kThreeSectionsWidthBreakpoint) const AddFilterTag(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
