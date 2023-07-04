import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/home.dart';

class EditHomeSectionsSheet extends ConsumerWidget {
  const EditHomeSectionsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeSections = ref.watch(homeSectionSettingsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(kDefaultPadding, kDefaultPadding, kDefaultPadding, kDefaultPadding / 2),
          child: Text('Úprava nástěnky', style: Theme.of(context).textTheme.titleLarge),
        ),
        Expanded(
          child: ReorderableListView.builder(
            itemCount: homeSections.length,
            itemBuilder: (_, index) => Padding(
              key: Key(homeSections[index].description),
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              child: Row(children: [
                const ReorderableDragStartListener(
                  index: 0,
                  child: Padding(
                    padding: EdgeInsets.only(left: kDefaultPadding, right: 2 * kDefaultPadding),
                    child: Icon(Icons.drag_indicator),
                  ),
                ),
                Text(homeSections[index].description),
              ]),
            ),
            onReorder: ref.read(homeSectionSettingsProvider.notifier).onReorder,
          ),
        )
      ],
    );
  }
}
