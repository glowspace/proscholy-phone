import 'package:flutter/material.dart';

const kdefaultSplitViewChildWidth = 360.0;
const kdefaultSplitViewMinDetailWidth = 560.0;

class SplitView extends StatelessWidget {
  final Widget child;
  final Widget detail;

  final double childWidth;
  final double minDetailWidth;

  final TextDirection textDirection;

  final bool showingOnlyDetail;

  const SplitView({
    super.key,
    required this.child,
    required this.detail,
    this.childWidth = kdefaultSplitViewChildWidth,
    this.minDetailWidth = kdefaultSplitViewMinDetailWidth,
    this.textDirection = TextDirection.ltr,
    this.showingOnlyDetail = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < childWidth + minDetailWidth) return detail;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: textDirection,
          children: [
            if (!showingOnlyDetail) ...[
              SizedBox(width: childWidth, child: child),
              VerticalDivider(width: 0.3, thickness: 0.3, color: Theme.of(context).dividerColor),
            ],
            Expanded(child: detail),
          ],
        );
      },
    );
  }
}
