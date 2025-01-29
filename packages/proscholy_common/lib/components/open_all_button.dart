import 'package:flutter/material.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/theme.dart';
import 'package:proscholy_common/utils/extensions.dart';

const double _navigateNextIconSize = 20;

class OpenAllButton extends StatelessWidget {
  final String title;
  final Function()? onTap;

  const OpenAllButton({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return HighlightableWidget(
      padding: EdgeInsets.zero,
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
