import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/settings.dart';

class FontSizeSlider extends StatelessWidget {
  const FontSizeSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final settingsProvider = context.read<SettingsProvider>();
    final fontSizeScale = context.select<SettingsProvider, double>((provider) => provider.fontSizeScale);

    return Row(
      children: [
        Text('A', style: theme.textTheme.bodyMedium, textScaleFactor: kMinimumFontSizeScale),
        Expanded(
          child: Slider.adaptive(
            min: kMinimumFontSizeScale,
            max: kMaximumFontSizeScale,
            value: fontSizeScale,
            onChanged: (value) => settingsProvider.fontSizeScale = value,
            activeColor: theme.colorScheme.primary,
            inactiveColor: theme.disabledColor,
          ),
        ),
        Text('A', style: theme.textTheme.bodyMedium, textScaleFactor: kMaximumFontSizeScale),
      ],
    );
  }
}
