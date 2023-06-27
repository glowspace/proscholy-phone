import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/presentation.dart';

class PresentationSettingsWidget extends ConsumerWidget {
  const PresentationSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final settings = ref.watch(presentationProvider.select((presentationProvider) => presentationProvider.settings));

    return Section(
      outsideTitle: 'Nastavení',
      margin: const EdgeInsets.all(kDefaultPadding),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      children: [
        SwitchListTile.adaptive(
          title: Text('Zobrazovat pozadí', style: textTheme.bodyMedium),
          value: settings.showBackground,
          onChanged: (value) =>
              ref.read(presentationProvider.notifier).changeSettings(settings.copyWith(showBackground: value)),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile.adaptive(
          title: Text('Světlé písmo', style: textTheme.bodyMedium),
          value: settings.darkMode,
          onChanged: (value) =>
              ref.read(presentationProvider.notifier).changeSettings(settings.copyWith(darkMode: value)),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile.adaptive(
          title: Text('Zobrazovat název písně', style: textTheme.bodyMedium),
          value: settings.showName,
          onChanged: (value) =>
              ref.read(presentationProvider.notifier).changeSettings(settings.copyWith(showName: value)),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile.adaptive(
          title: Text('Zobrazovat všechna písmena velká', style: textTheme.bodyMedium),
          value: settings.allCapital,
          onChanged: (value) =>
              ref.read(presentationProvider.notifier).changeSettings(settings.copyWith(allCapital: value)),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
