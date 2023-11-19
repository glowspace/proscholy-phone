import 'package:flutter/material.dart';
import 'package:zpevnik/components/navigation/bottom_navigation_bar.dart';
import 'package:zpevnik/routing/safe_area_wrapper.dart';
import 'package:zpevnik/utils/extensions.dart';

class CustomScaffold extends StatelessWidget {
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Widget? floatingActionButton;
  final Widget body;

  final bool useMaxWidth;

  const CustomScaffold({
    super.key,
    this.backgroundColor,
    this.appBar,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.floatingActionButton,
    this.useMaxWidth = true,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      bottomNavigationBar:
          bottomNavigationBar ?? (MediaQuery.of(context).isTablet ? null : const CustomBottomNavigationBar()),
      bottomSheet: bottomSheet,
      floatingActionButton: floatingActionButton,
      body: body,
    );

    if (useMaxWidth) return SafeAreaWrapper(child: scaffold);

    return scaffold;
  }
}
