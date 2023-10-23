import 'package:flutter/material.dart';
import 'package:zpevnik/components/navigation/navigation_rail.dart';
import 'package:zpevnik/utils/extensions.dart';

class NavigationRailWrapper extends StatelessWidget {
  final Widget Function(BuildContext context) builder;

  const NavigationRailWrapper({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).isTablet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // make the widget display from right to left, so the navigation rail shadow is visible
        textDirection: TextDirection.rtl,
        children: [
          Expanded(child: builder(context)),
          const CustomNavigationRail(),
        ],
      );
    }

    return builder(context);
  }
}
