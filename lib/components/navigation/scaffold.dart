import 'package:flutter/material.dart';
import 'package:zpevnik/components/navigation/bottom_navigation_bar.dart';
import 'package:zpevnik/constants.dart';
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
    final mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, constraints) => MediaQuery(
        data: mediaQuery.copyWith(
          padding:
              mediaQuery.padding + EdgeInsets.symmetric(horizontal: _computeAdditionalPadding(context, constraints)),
        ),
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar,
          bottomNavigationBar: bottomNavigationBar ?? (mediaQuery.isTablet ? null : const CustomBottomNavigationBar()),
          bottomSheet: bottomSheet,
          floatingActionButton: floatingActionButton,
          body: body,
        ),
      ),
    );
  }

  double _computeAdditionalPadding(BuildContext context, BoxConstraints constraints) {
    final mediaQuery = MediaQuery.of(context);

    return (useMaxWidth && kScaffoldMaxWidth < constraints.maxWidth)
        ? (constraints.maxWidth - kScaffoldMaxWidth - mediaQuery.padding.horizontal) / 2
        : 0;
  }
}
