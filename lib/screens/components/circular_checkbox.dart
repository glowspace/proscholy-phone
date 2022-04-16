import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';

class CircularCheckbox extends StatelessWidget {
  final bool selected;

  const CircularCheckbox({Key? key, required this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return AnimatedCrossFade(
      firstChild: Icon(Icons.check_circle, color: appTheme.chordColor),
      secondChild: Icon(Icons.radio_button_off, color: appTheme.disabledColor),
      crossFadeState: selected ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: kDefaultAnimationDuration,
    );
  }
}
