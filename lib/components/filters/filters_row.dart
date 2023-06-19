import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/filters/add_filter_tag.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/components/filters/filter_tag.dart';
import 'package:zpevnik/providers/tags.dart';
import 'package:zpevnik/utils/extensions.dart';

class FiltersRow extends ConsumerWidget {
  const FiltersRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final mediaQuery = MediaQuery.of(context);
    final showingThreeSections = mediaQuery.isTablet && mediaQuery.isLandscape;

    final selectedTags = ref.watch(selectedTagsProvider);

    if (selectedTags.isEmpty && showingThreeSections) return Container();

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
                if (!showingThreeSections) const AddFilterTag(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
