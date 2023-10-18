import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:zpevnik/components/navigation/bottom_navigation_bar.dart';
import 'package:zpevnik/components/navigation/navigation_rail.dart';
import 'package:zpevnik/utils/extensions.dart';

class CustomScaffold extends StatelessWidget {
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Widget? floatingActionButton;
  final Widget body;

  final bool hideNavigationRail;

  const CustomScaffold({
    super.key,
    this.backgroundColor,
    this.appBar,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.floatingActionButton,
    this.hideNavigationRail = false,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (mediaQuery.isTablet) {
      final scaffold = Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        body: body,
      );

      if (hideNavigationRail) return scaffold;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // make the widget display from right to left, so the navigation rail shadow is visible
        textDirection: TextDirection.rtl,
        children: [
          Expanded(child: scaffold),
          const CustomNavigationRail(),
        ],
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar ?? const CustomBottomNavigationBar(),
      bottomSheet: bottomSheet,
      floatingActionButtonLocation: floatingActionButton is ExpandableFab ? ExpandableFab.location : null,
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}
