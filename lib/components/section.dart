import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class Section extends StatelessWidget {
  final String? title;

  final Widget child;
  final Widget? action;

  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const Section({
    Key? key,
    this.title,
    required this.child,
    this.action,
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
          Row(children: [
            Expanded(child: Text(title!, style: theme.textTheme.titleLarge)),
            if (action != null) action!,
          ]),
          const SizedBox(height: kDefaultPadding / 2),
          section,
        ],
      );
    }

    return section;
  }
}
