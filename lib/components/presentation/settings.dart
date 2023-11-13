import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/bottom_sheet_section.dart';
import 'package:zpevnik/components/selector_widget.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/presentation.dart';
import 'package:zpevnik/providers/presentation.dart';

class PresentationSettingsWidget extends ConsumerWidget {
  final bool onExternalDisplay;

  const PresentationSettingsWidget({super.key, required this.onExternalDisplay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final settings = ref.watch(presentationProvider.select((presentation) => presentation.settings));

    return BottomSheetSection(
      title: 'Nastavení promítání',
      childrenPadding: false,
      children: [
        if (onExternalDisplay)
          SwitchListTile.adaptive(
            title: Text('Světlé písmo', style: textTheme.bodyMedium),
            value: settings.darkMode,
            dense: true,
            onChanged: (value) =>
                ref.read(presentationProvider.notifier).changeSettings(settings.copyWith(darkMode: value)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
          ),
        SwitchListTile.adaptive(
          title: Text('Zobrazovat název písně', style: textTheme.bodyMedium),
          value: settings.showName,
          dense: true,
          onChanged: (value) =>
              ref.read(presentationProvider.notifier).changeSettings(settings.copyWith(showName: value)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
        ),
        SwitchListTile.adaptive(
          title: Text('Zobrazovat všechna písmena velká', style: textTheme.bodyMedium),
          value: settings.allCapital,
          dense: true,
          onChanged: (value) =>
              ref.read(presentationProvider.notifier).changeSettings(settings.copyWith(allCapital: value)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
        ),
        SelectorWidget(
          title: 'Zarovnání textu',
          padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding / 2),
          segments: const [
            ButtonSegment(value: PresentationAlignment.top, icon: Icon(Icons.align_vertical_top)),
            ButtonSegment(value: PresentationAlignment.center, icon: Icon(Icons.align_vertical_center)),
            ButtonSegment(value: PresentationAlignment.bottom, icon: Icon(Icons.align_vertical_bottom)),
          ],
          selected: ref.watch(presentationProvider.select((presentation) => presentation.settings.alignment)) ??
              PresentationAlignment.center,
          onSelected: (value) =>
              ref.read(presentationProvider.notifier).changeSettings(settings.copyWith(alignment: value)),
        ),
      ],
    );
  }
}
