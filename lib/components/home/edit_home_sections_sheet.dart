import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/bottom_sheet_section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/home.dart';

class EditHomeSectionsSheet extends ConsumerWidget {
  const EditHomeSectionsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeSections = ref.watch(homeSectionSettingsProvider);

    return BottomSheetSection(
      title: 'Úprava nástěnky',
      tip: 'Seřaďte si jednotlivé sekce podle vašich preferencí',
      childrenPadding: false,
      children: [
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: homeSections.length,
          itemBuilder: (_, index) => Padding(
            key: Key(homeSections[index].description),
            padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: 2 * kDefaultPadding / 3),
            child: Row(children: [
              const ReorderableDragStartListener(
                index: 0,
                child: Padding(
                  padding: EdgeInsets.only(right: 2 * kDefaultPadding),
                  child: Icon(Icons.drag_indicator),
                ),
              ),
              Text(homeSections[index].description),
            ]),
          ),
          onReorder: ref.read(homeSectionSettingsProvider.notifier).onReorder,
        ),
      ],
    );
  }
}
