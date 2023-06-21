import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/presentation.dart';
import 'package:zpevnik/providers/presentation.dart';

class PresentationSettingsWidget extends StatefulWidget {
  const PresentationSettingsWidget({super.key});

  @override
  State<PresentationSettingsWidget> createState() => _PresentationSettingsState();
}

class _PresentationSettingsState extends State<PresentationSettingsWidget> {
  late PresentationSettings _presentationSettings;

  @override
  void initState() {
    super.initState();

    _presentationSettings = context.read<PresentationProvider>().settings;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Section(
      outsideTitle: 'Nastavení',
      margin: const EdgeInsets.all(kDefaultPadding),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      children: [
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
      ],
    );
  }

  void _settingsChanged(Function setState) {
    setState();

    context.read<PresentationProvider>().changeSettings(_presentationSettings);
  }
}
