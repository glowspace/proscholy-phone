import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

const double _iconSize = 24;

class IconItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconItem({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: _iconSize),
        const SizedBox(width: kDefaultPadding),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}
