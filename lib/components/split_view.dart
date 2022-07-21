import 'package:flutter/material.dart';

class SplitView extends StatelessWidget {
  final Widget child;
  final Widget subChild;

  const SplitView({Key? key, required this.child, required this.subChild}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: child),
        const VerticalDivider(width: 0),
        Flexible(flex: 3, child: subChild),
      ],
    );
  }
}
