import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/bottom_sheet_section.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/home.dart';

class EditHomeSectionsSheet extends ConsumerWidget {
  const EditHomeSectionsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeSections = ref.watch(homeSectionSettingsProvider);
    final disabledHomeSections = HomeSection.values.whereNot((homeSection) => homeSections.contains(homeSection));

    return BottomSheetSection(
      title: 'Úprava nástěnky',
      childrenPadding: false,
      children: [
        const SizedBox(height: kDefaultPadding),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: homeSections.length,
          itemBuilder: (_, index) => Padding(
            key: Key(homeSections[index].description),
            padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding / 2),
            child: Row(children: [
              const ReorderableDragStartListener(
                index: 0,
                child: Padding(
                  padding: EdgeInsets.only(right: 2 * kDefaultPadding),
                  child: Icon(Icons.drag_indicator),
                ),
              ),
              Text(homeSections[index].description),
              const Spacer(),
              Highlightable(
                icon: const Icon(Icons.remove),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                onTap: () => ref.read(homeSectionSettingsProvider.notifier).remove(homeSections[index]),
              ),
            ]),
          ),
          onReorder: ref.read(homeSectionSettingsProvider.notifier).onReorder,
        ),
        const Divider(height: kDefaultPadding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Neaktivní sekce', style: Theme.of(context).textTheme.labelLarge),
              for (final homeSection in disabledHomeSections)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                  child: Row(children: [
                    Text(homeSection.description),
                    const Spacer(),
                    Highlightable(
                      icon: const Icon(Icons.add),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      onTap: () => ref.read(homeSectionSettingsProvider.notifier).add(homeSection),
                    ),
                  ]),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
