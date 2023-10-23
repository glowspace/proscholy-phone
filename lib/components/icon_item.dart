import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class IconItem extends StatelessWidget {
  final IconData icon;
  final IconData? trailingIcon;
  final String text;
  final String? trailingtext;

  final Color? iconColor;

  final double iconSize;

  const IconItem({
    super.key,
    required this.icon,
    this.trailingIcon,
    required this.text,
    this.trailingtext,
    this.iconColor,
    this.iconSize = kDefaultIconSize,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, color: iconColor, size: iconSize),
        const SizedBox(width: kDefaultPadding),
        Expanded(child: Text(text, style: textTheme.bodyMedium)),
        if (trailingtext != null) Text(trailingtext!, style: textTheme.bodySmall),
        if (trailingIcon != null) Icon(trailingIcon, size: 0.8 * iconSize),
      ],
    );
  }
}
