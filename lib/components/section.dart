import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';

class Section extends StatelessWidget {
  final Widget child;
  final String? title;

  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const Section({
    Key? key,
    required this.child,
    this.title,
    this.margin,
    this.padding = const EdgeInsets.all(kDefaultPadding),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final section = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(kDefaultRadius),
      ),
      child: child,
    );

    if (title != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title!, style: theme.textTheme.titleLarge),
          const SizedBox(height: kDefaultPadding / 2),
          section,
        ],
      );
    }

    return section;
  }
}
