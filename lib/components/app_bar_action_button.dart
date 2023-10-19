import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';

class AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final EdgeInsets padding;
  final Function()? onTap;

  const AppBarActionButton({
    super.key,
    required this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Highlightable(onTap: onTap, padding: padding, icon: const Icon(Icons.filter_alt));
  }
}
