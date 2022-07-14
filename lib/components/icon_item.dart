import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class IconItem extends StatelessWidget {
  final IconData icon;
  final String text;

  final double iconSize;

  const IconItem({
    Key? key,
    required this.icon,
    required this.text,
    this.iconSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: iconSize),
        const SizedBox(width: kDefaultPadding),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}
