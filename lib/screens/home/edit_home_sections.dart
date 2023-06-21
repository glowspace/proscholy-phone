import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/providers/home.dart';

class EditHomeSectionsScreen extends ConsumerStatefulWidget {
  const EditHomeSectionsScreen({super.key});

  @override
  ConsumerState<EditHomeSectionsScreen> createState() => _EditHomeSectionsScreenState();
}

class _EditHomeSectionsScreenState extends ConsumerState<EditHomeSectionsScreen> {
  @override
  Widget build(BuildContext context) {
    final homeSections = ref.watch(homeSectionSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Úprava nástěnky'),
        actions: [
          HighlightableIconButton(
            onTap: () {
              ref.read(homeSectionSettingsProvider.notifier).save();

              context.pop();
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: ReorderableListView.builder(
          itemCount: homeSections.length,
          itemBuilder: (_, index) => Text(
            homeSections[index].description,
            key: Key(homeSections[index].description),
          ),
          onReorder: ref.read(homeSectionSettingsProvider.notifier).onReorder,
        ),
      ),
    );
  }
}
