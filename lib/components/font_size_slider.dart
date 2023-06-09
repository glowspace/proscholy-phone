import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/settings.dart';

class FontSizeSlider extends StatelessWidget {
  const FontSizeSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(children: [
      Text('A', style: theme.textTheme.bodyMedium, textScaleFactor: kMinimumFontSizeScale),
      Expanded(
        child: Consumer(
          builder: (_, ref, __) => Slider.adaptive(
            min: kMinimumFontSizeScale,
            max: kMaximumFontSizeScale,
            value: ref.watch(settingsProvider.select((settings) => settings.fontSizeScale)),
            onChanged: ref.read(settingsProvider.notifier).changeFontSizeScale,
            activeColor: theme.colorScheme.primary,
            inactiveColor: theme.disabledColor,
          ),
        ),
      ),
      Text('A', style: theme.textTheme.bodyMedium, textScaleFactor: kMaximumFontSizeScale),
    ]);
  }
}
