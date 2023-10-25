import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/components/filters/filters_section.dart';
import 'package:zpevnik/providers/tags.dart';
import 'package:zpevnik/utils/extensions.dart';

class FiltersWidget extends ConsumerWidget {
  const FiltersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      bottom: false,
      child: ListView.builder(
        controller: PrimaryScrollController.of(context),
        padding: EdgeInsets.only(
          top: context.isSearching ? 0 : kDefaultPadding,
          bottom: MediaQuery.paddingOf(context).bottom,
        ),
        addRepaintBoundaries: false,
        itemCount: supportedTagTypes.length,
        itemBuilder: (_, index) => FiltersSection(
          title: supportedTagTypes[index].description,
          tags: ref.watch(tagsProvider(supportedTagTypes[index])),
        ),
      ),
    );
  }
}
