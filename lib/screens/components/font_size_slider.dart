import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/platform/components/slider.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/theme.dart';

class FontSizeSlider extends StatelessWidget {
  const FontSizeSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final settingsProvider = context.watch<SettingsProvider>();

    return Row(
      children: [
        RichText(text: TextSpan(text: 'A', style: appTheme.bodyTextStyle), textScaleFactor: kMinimumFontSizeScale),
        Expanded(
          child: PlatformSlider(
            min: kMinimumFontSizeScale,
            max: kMaximumFontSizeScale,
            value: settingsProvider.fontSizeScale,
            onChanged: (value) => settingsProvider.fontSizeScale = value,
            activeColor: appTheme.chordColor,
            inactiveColor: appTheme.disabledColor,
          ),
        ),
        RichText(text: TextSpan(text: 'A', style: appTheme.bodyTextStyle), textScaleFactor: kMaximumFontSizeScale),
      ],
    );
  }
}