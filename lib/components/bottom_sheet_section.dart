import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class BottomSheetSection extends StatelessWidget {
  final String title;
  final String? tip;
  final bool childrenPadding;
  final List<Widget> children;

  const BottomSheetSection({
    super.key,
    required this.title,
    this.tip,
    this.childrenPadding = true,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                if (tip != null) ...[
                  Text(tip!, style: Theme.of(context).textTheme.labelLarge),
                ],
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  childrenPadding ? kDefaultPadding : 0,
                  0,
                  childrenPadding ? kDefaultPadding : 0,
                  MediaQuery.paddingOf(context).bottom + kDefaultPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
