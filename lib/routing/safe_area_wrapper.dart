import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class SafeAreaWrapper extends StatelessWidget {
  final Widget child;

  const SafeAreaWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, constraints) => MediaQuery(
        data: mediaQuery.copyWith(
          padding:
              mediaQuery.padding + EdgeInsets.symmetric(horizontal: _computeAdditionalPadding(context, constraints)),
        ),
        child: child,
      ),
    );
  }

  double _computeAdditionalPadding(BuildContext context, BoxConstraints constraints) {
    final mediaQuery = MediaQuery.of(context);

    return (kScaffoldMaxWidth < constraints.maxWidth)
        ? (constraints.maxWidth - kScaffoldMaxWidth - mediaQuery.padding.horizontal) / 2
        : 0;
  }
}
