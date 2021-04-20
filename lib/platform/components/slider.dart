import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/platform/mixin.dart';

class PlatformSlider extends StatelessWidget with PlatformWidgetMixin {
  final double value;
  final double min;
  final double max;
  final Function(double) onChanged;
  final Color activeColor;
  final Color inactiveColor;

  const PlatformSlider({
    Key key,
    this.value,
    this.min,
    this.max,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget androidWidget(BuildContext context) => Slider(
        min: min,
        max: max,
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      );

  @override
  Widget iOSWidget(BuildContext context) => CupertinoSlider(
        min: min,
        max: max,
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
      );
}
