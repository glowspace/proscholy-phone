import 'package:flutter/material.dart';

class SplitView extends StatelessWidget {
  final Widget child;
  final Widget subChild;

  final int childFlex;
  final int subChildFlex;

  const SplitView({
    super.key,
    required this.child,
    required this.subChild,
    this.childFlex = 1,
    this.subChildFlex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: childFlex, child: child),
        VerticalDivider(width: 0.3, color: Theme.of(context).dividerColor),
        Flexible(flex: subChildFlex, child: subChild),
      ],
    );
  }
}
