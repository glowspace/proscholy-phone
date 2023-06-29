import 'package:flutter/material.dart';

class SplitView extends StatelessWidget {
  final Widget child;
  final Widget subChild;

  const SplitView({super.key, required this.child, required this.subChild});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: child),
        VerticalDivider(width: 0.3, color: Theme.of(context).dividerColor),
        Flexible(flex: 3, child: subChild),
      ],
    );
  }
}
