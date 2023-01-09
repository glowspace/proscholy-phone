import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class IconItem extends StatelessWidget {
  final IconData icon;
  final IconData? trailingIcon;
  final String text;

  final Color? iconColor;

  final double iconSize;

  const IconItem({
    Key? key,
    required this.icon,
    this.trailingIcon,
    required this.text,
    this.iconColor,
    this.iconSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: iconSize),
        const SizedBox(width: kDefaultPadding),
        Expanded(child: Text(text)),
        if (trailingIcon != null) Icon(trailingIcon, size: 0.8 * iconSize),
      ],
    );
  }
}
