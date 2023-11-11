import 'dart:math';

import 'package:flutter/material.dart';

const kDefaultSplitViewChildMinWidth = 240.0;
const kDefaultSplitViewChildMaxWidth = 320.0;
const kDefaultSplitViewDetailMinWidth = 480.0;
const kDefaultSplitViewChildWidthFactor = 0.3;

class SplitView extends StatelessWidget {
  final Widget child;
  final Widget detail;

  final double minChildWidth;
  final double maxChildWidth;
  final double detailMinWidth;
  final double childWidthFactor;

  final TextDirection textDirection;

  final bool showingOnlyDetail;

  const SplitView({
    super.key,
    required this.child,
    required this.detail,
    this.minChildWidth = kDefaultSplitViewChildMinWidth,
    this.maxChildWidth = kDefaultSplitViewChildMaxWidth,
    this.detailMinWidth = kDefaultSplitViewDetailMinWidth,
    this.childWidthFactor = kDefaultSplitViewChildWidthFactor,
    this.textDirection = TextDirection.ltr,
    this.showingOnlyDetail = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final childWidth = min(max(kDefaultSplitViewChildMinWidth, childWidthFactor * constraints.maxWidth),
            kDefaultSplitViewChildMaxWidth);

        if (constraints.maxWidth < childWidth + detailMinWidth) return detail;

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
