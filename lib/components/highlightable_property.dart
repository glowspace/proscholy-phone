import 'package:flutter/material.dart';

class HighlightableForegroundColor extends MaterialStateProperty<Color?> {
  final BuildContext context;

  HighlightableForegroundColor(this.context);

  @override
  Color? resolve(Set<MaterialState> states) {
    final theme = Theme.of(context);

    if (states.contains(MaterialState.pressed)) {
      return theme.colorScheme.primaryContainer.withAlpha(0x80);
    } else if (states.contains(MaterialState.disabled)) {
      return theme.disabledColor;
    } else {
      return theme.colorScheme.primary;
    }
  }
}
