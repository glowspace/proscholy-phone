import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/theme.dart';

class FontSizeSlider extends StatelessWidget {
  const FontSizeSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final settingsProvider = context.read<SettingsProvider>();
    final fontSizeScale = context.select<SettingsProvider, double>((provider) => provider.fontSizeScale);

    return Row(
      children: [
        Text('A', style: appTheme.bodyTextStyle, textScaleFactor: kMinimumFontSizeScale),
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: Slider.adaptive(
              min: kMinimumFontSizeScale,
              max: kMaximumFontSizeScale,
              value: fontSizeScale,
              onChanged: (value) => settingsProvider.fontSizeScale = value,
              activeColor: appTheme.chordColor,
              inactiveColor: appTheme.disabledColor,
            ),
          ),
        ),
        Text('A', style: appTheme.bodyTextStyle, textScaleFactor: kMaximumFontSizeScale),
      ],
    );
  }
}
