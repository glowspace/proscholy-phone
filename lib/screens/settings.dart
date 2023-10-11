import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/custom/close_button.dart';
import 'package:zpevnik/components/font_size_slider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/logo.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/components/selector_widget.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/routing/router.dart';
import 'package:zpevnik/utils/extensions.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(leading: const CustomCloseButton(), title: const Logo(), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildAppSettings(context, ref),
              _buildSongSettings(context, ref),
              Highlightable(
                onTap: () => context.push('/about'),
                textStyle: textTheme.bodySmall,
                child: const Text('O projektu'),
              ),
              const SizedBox(height: kDefaultPadding),
            ],
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
      outsideTitle: 'Nastavení',
      margin: const EdgeInsets.all(kDefaultPadding),
      children: [
        SwitchListTile.adaptive(
          title: Text('Tmavý mód', style: textTheme.bodyMedium),
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
              Highlightable(
                highlightBackground: true,
                borderRadius: BorderRadius.circular(kDefaultRadius),
                onTap: () => showColorPickerDialog(
                  context,
                  ref.watch(settingsProvider.select((settings) => Color(settings.seedColor))),
                  pickersEnabled: {ColorPickerType.primary: true, ColorPickerType.accent: false},
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
