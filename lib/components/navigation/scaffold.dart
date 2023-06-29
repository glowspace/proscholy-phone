import 'package:flutter/material.dart';
import 'package:zpevnik/components/navigation/bottom_navigation_bar.dart';
import 'package:zpevnik/components/navigation/navigation_rail.dart';
import 'package:zpevnik/utils/extensions.dart';

class CustomScaffold extends StatelessWidget {
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget body;

  const CustomScaffold({
    super.key,
    this.backgroundColor,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (mediaQuery.isTablet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // make the widget display from right to left, so the navigation rail shadow is visible
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Scaffold(
              backgroundColor: backgroundColor,
              appBar: appBar,
              bottomNavigationBar: bottomNavigationBar,
              floatingActionButton: floatingActionButton,
              body: body,
            ),
          ),
          const CustomNavigationRail(),
        ],
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar ?? const CustomBottomNavigationBar(),
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}
