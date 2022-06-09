import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';

class Section extends StatelessWidget {
  final Widget child;

  final EdgeInsets margin;
  final EdgeInsets padding;

  const Section({
    Key? key,
    required this.child,
    this.margin = const EdgeInsets.all(kDefaultMargin),
    this.padding = const EdgeInsets.all(kDefaultPadding),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: appTheme.containerColor,
        borderRadius: BorderRadius.circular(kDefaultRadius),
      ),
      child: child,
    );
  }
}
