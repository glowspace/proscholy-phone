import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/extensions.dart';

const double _navigateNextIconSize = 20;

class OpenAllButton extends StatelessWidget {
  final String title;
  final Function()? onTap;

  const OpenAllButton({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return HighlightableTextButton(
      textStyle: TextStyle(
        fontSize: 14,
        color: Theme.of(context).brightness.isLight ? lightTextColor : darkTextColor,
        fontWeight: FontWeight.w500,
      ),
      onTap: onTap,
      child: Row(children: [Text(title), const Icon(Icons.navigate_next, size: _navigateNextIconSize)]),
    );
  }
}
