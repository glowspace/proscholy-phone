import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proscholy_common/components/custom/close_button.dart';
import 'package:proscholy_common/components/font_size_slider.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/components/section.dart';
import 'package:proscholy_common/components/selector_widget.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/providers/settings.dart';
import 'package:proscholy_common/routing/safe_area_wrapper.dart';
import 'package:proscholy_common/utils/extensions.dart';
import 'package:proscholy_common/utils/url_launcher.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SafeAreaWrapper(
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(leading: const CustomCloseButton(), title: const Text('Nastavení')),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildAppSettings(context, ref),
                _buildSongSettings(context, ref),
                HighlightableWidget(
                  onTap: ref.read(settingsProvider.notifier).reset,
                  padding: const EdgeInsets.all(kDefaultPadding / 2),
                  textStyle: theme.textTheme.bodySmall,
                  child: const Text('Resetovat nastavení'),
                ),
                const SizedBox(height: kDefaultPadding),
                HighlightableWidget(
                  onTap: () => isZP ? context.push('/about') : launch('https://evangelickyzpevnik.cz/o-zpevniku'),
                  padding: const EdgeInsets.all(kDefaultPadding / 2),
                  textStyle: textTheme.bodySmall,
                  child: const Text('O projektu'),
                ),
                const SizedBox(height: kDefaultPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppSettings(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final systemDarkModeEnabled = MediaQuery.of(context).platformBrightness.isDark;

    return Section(
      margin: const EdgeInsets.all(kDefaultPadding),
      children: [
        SwitchListTile.adaptive(
          title: Text('Tmavý mód', style: textTheme.bodyMedium),
          activeColor: theme.colorScheme.primary,
          value: ref.watch(settingsProvider.select((settings) => settings.darkModeEnabled)) ?? systemDarkModeEnabled,
          onChanged: (value) =>
              ref.read(settingsProvider.notifier).changeDarkModeEnabled(value == systemDarkModeEnabled ? null : value),
          contentPadding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding).copyWith(right: 1.5 * kDefaultPadding),
          child: Row(
            children: [
              Expanded(child: Text('Barevné schéma', style: textTheme.bodyMedium)),
              HighlightableWidget(
                highlightBackground: true,
                borderRadius: BorderRadius.circular(kDefaultRadius),
                onTap: () => showColorPickerDialog(
                  context,
                  ref.watch(settingsProvider.select((settings) => Color(settings.seedColor))),
                  pickersEnabled: {ColorPickerType.primary: true, ColorPickerType.accent: false},
                  enableShadesSelection: false,
                ).then((color) => ref.read(settingsProvider.notifier).changeSeedColor(color.value)),
                child: Ink(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: ref.watch(settingsProvider.select((settings) => Color(settings.seedColor))),
                    borderRadius: BorderRadius.circular(kDefaultRadius),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSongSettings(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final showChords = ref.watch(settingsProvider.select((settings) => settings.showChords));
    final showMusicalNotes = ref.watch(settingsProvider.select((settings) => settings.showMusicalNotes));

    final accidentalsStyle = textTheme.bodyMedium?.copyWith(
      fontFamily: 'KaiseiHarunoUmi',
      color: showChords ? null : theme.disabledColor,
    );

    return Section(
      outsideTitle: 'Nastavení písní',
      margin: const EdgeInsets.all(kDefaultPadding),
      children: [
        SelectorWidget(
          title: 'Posuvky',
          onSelected: ref.read(settingsProvider.notifier).changeAccidentals,
          isEnabled: showChords,
          segments: [
            ButtonSegment(value: 0, label: Text('#', style: accidentalsStyle, textAlign: TextAlign.center)),
            ButtonSegment(value: 1, label: Text('♭', style: accidentalsStyle, textAlign: TextAlign.center)),
          ],
          selected: ref.watch(settingsProvider.select((settings) => settings.accidentals)),
        ),
        const Divider(),
        SwitchListTile.adaptive(
          title: Text('Akordy', style: textTheme.bodyMedium),
          activeColor: theme.colorScheme.primary,
          value: showChords,
          onChanged: (value) => ref.read(settingsProvider.notifier).changeShowChords(value),
          contentPadding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        ),
        const Divider(),
        SwitchListTile.adaptive(
          title: Text('Zobrazit noty', style: textTheme.bodyMedium),
          activeColor: theme.colorScheme.primary,
          value: showMusicalNotes,
          onChanged: (value) => ref.read(settingsProvider.notifier).changeShowMusicalNotes(value),
          contentPadding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        ),
        const Divider(),
        const SizedBox(height: kDefaultPadding / 2),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [Text('Velikost písma'), FontSizeSlider()],
          ),
        ),
      ],
    );
  }
}
