import 'package:flutter/material.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';

const _availableFontSizes = [48, 56, 64, 72, 80, 88, 96, 104, 112, 120];

class PresentationSettings extends StatefulWidget {
  const PresentationSettings({super.key});

  @override
  State<PresentationSettings> createState() => _PresentationSettingsState();
}

class _PresentationSettingsState extends State<PresentationSettings> {
  late int _fontSizeScale = 64;
  late bool _showName = false;
  late bool _allCapital = false;

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
            value: _fontSizeScale,
            items: [
              for (final fontSize in _availableFontSizes) DropdownMenuItem(value: fontSize, child: Text('$fontSize')),
            ],
            onChanged: (value) => setState(() => _fontSizeScale = value!),
          ),
        ]),
        SwitchListTile.adaptive(
          title: Text('Zobrazovat název písně', style: textTheme.bodyMedium),
          value: _showName,
          onChanged: (value) => setState(() => _showName = value),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile.adaptive(
          title: Text('Zobrazovat všechna písmena velká', style: textTheme.bodyMedium),
          value: _allCapital,
          onChanged: (value) => setState(() => _allCapital = value),
          contentPadding: EdgeInsets.zero,
        ),
      ]),
    );
  }
}
