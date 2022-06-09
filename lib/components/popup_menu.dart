import 'package:flutter/material.dart';
import 'package:zpevnik/theme.dart';

class PopupMenu extends StatelessWidget {
  final List<Widget> children;
  final Border? border;

  const PopupMenu({
    Key? key,
    this.children = const [],
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppTheme.of(context).backgroundColor, border: border),
      child: IntrinsicWidth(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children)),
    );
  }
}
