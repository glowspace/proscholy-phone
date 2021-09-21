import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/platform/mixin.dart';

class PlatformSlider extends StatelessWidget with PlatformMixin {
  final double value;
  final double min;
  final double max;
  final Function(double)? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;

  const PlatformSlider({
    Key? key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget buildAndroid(BuildContext context) {
    return Slider(
      min: min,
      max: max,
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
    );
  }

  @override
  Widget buildIos(BuildContext context) {
    return CupertinoSlider(
      min: min,
      max: max,
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
    );
  }
}
