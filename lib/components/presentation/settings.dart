import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/presentation_settings.dart';
import 'package:zpevnik/providers/presentation.dart';

const _availableFontSizes = [96, 104, 112, 120, 128, 136, 144, 152, 160];

class PresentationSettingsWidget extends StatefulWidget {
  const PresentationSettingsWidget({super.key});

  @override
  State<PresentationSettingsWidget> createState() => _PresentationSettingsState();
}

class _PresentationSettingsState extends State<PresentationSettingsWidget> {
  PresentationSettings _presentationSettings = defaultPresentationSettings;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Section(
      title: Text('Nastavení', style: textTheme.titleMedium),
      margin: const EdgeInsets.all(kDefaultPadding),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(children: [
        Row(children: [
          Text('Velikost písma', style: textTheme.bodyMedium),
          const Spacer(),
          DropdownButton<int>(
            value: _presentationSettings.fontSize,
            items: [
              for (final fontSize in _availableFontSizes) DropdownMenuItem(value: fontSize, child: Text('$fontSize')),
            ],
            onChanged: (value) => _settingsChanged(
              () => setState(() => _presentationSettings = _presentationSettings.copyWith(fontSize: value)),
            ),
          ),
        ]),
        SwitchListTile.adaptive(
          title: Text('Zobrazovat pozadí', style: textTheme.bodyMedium),
          value: _presentationSettings.showBackground,
          onChanged: (value) => _settingsChanged(() => setState(
                () => setState(() => _presentationSettings = _presentationSettings.copyWith(showBackground: value)),
              )),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile.adaptive(
          title: Text('Světlé písmo', style: textTheme.bodyMedium),
          value: _presentationSettings.darkMode,
          onChanged: (value) => _settingsChanged(
            () => setState(() => _presentationSettings = _presentationSettings.copyWith(darkMode: value)),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile.adaptive(
          title: Text('Zobrazovat název písně', style: textTheme.bodyMedium),
          value: _presentationSettings.showName,
          onChanged: (value) => _settingsChanged(
            () => setState(() => _presentationSettings = _presentationSettings.copyWith(showName: value)),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile.adaptive(
          title: Text('Zobrazovat všechna písmena velká', style: textTheme.bodyMedium),
          value: _presentationSettings.allCapital,
          onChanged: (value) => _settingsChanged(
            () => setState(() => _presentationSettings = _presentationSettings.copyWith(allCapital: value)),
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ]),
    );
  }

  void _settingsChanged(Function setState) {
    setState();

    context.read<PresentationProvider>().changeSettings(_presentationSettings);
  }
}
