import 'package:flutter/material.dart';

class SplitView extends StatelessWidget {
  final Widget child;
  final Widget detail;

  final int childFlex;
  final int detailFlex;

  final bool showingOnlyDetail;

  const SplitView({
    super.key,
    required this.child,
    required this.detail,
    this.childFlex = 1,
    this.detailFlex = 1,
    this.showingOnlyDetail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!showingOnlyDetail) ...[
          Expanded(flex: childFlex, child: child),
          VerticalDivider(width: 0.3, color: Theme.of(context).dividerColor),
        ],
        Flexible(flex: detailFlex, child: detail),
      ],
    );
  }
}
