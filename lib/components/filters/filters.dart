import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/components/filters/filters_section.dart';
import 'package:zpevnik/providers/tags.dart';

class FiltersWidget extends ConsumerWidget {
  const FiltersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OrientationBuilder(builder: (context, orientation) {
      // TODO: this should be handled when opening the bottom sheet
      // if (orientation == Orientation.landscape && NavigationProvider.of(context).isFiltersOpen) {
      //   context.pop();
      // }

      return SafeArea(
        top: false,
        child: ListView.builder(
          controller: PrimaryScrollController.of(context),
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
          addRepaintBoundaries: false,
          itemCount: supportedTagTypes.length,
          itemBuilder: (_, index) => FiltersSection(
            title: supportedTagTypes[index].description,
            tags: ref.watch(tagsProvider(supportedTagTypes[index])),
            isLast: index == supportedTagTypes.length - 1,
          ),
        ),
      );
    });
  }
}
