import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class Section extends StatelessWidget {
  final String? outsideTitle;
  final bool outsideTitleLarge;
  final String? insideTitle;
  final IconData? insideTitleIcon;
  final Color? insideTitleIconColor;

  final List<Widget> children;
  final Widget? action;

  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const Section({
    super.key,
    this.outsideTitle,
    this.outsideTitleLarge = false,
    this.insideTitle,
    this.insideTitleIcon,
    this.insideTitleIconColor,
    required this.children,
    this.action,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (outsideTitle != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 2 / 3 * kDefaultPadding),
              child: Row(children: [
                Expanded(
                  child: Text(
                    outsideTitle!,
                    style: outsideTitleLarge ? theme.textTheme.titleLarge : theme.textTheme.titleMedium,
                  ),
                ),
                if (action != null) action!,
              ]),
            ),
          Container(
            padding: padding,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(kDefaultRadius),
            ),
            clipBehavior: Clip.antiAlias,
            // needs another wrapping in material widget, so inkwell highlight is visible
            child: Material(
              color: theme.colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (insideTitle != null) ...[
                    Padding(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: Row(children: [
                        Icon(insideTitleIcon, color: insideTitleIconColor),
                        const SizedBox(width: kDefaultPadding),
                        Text(insideTitle!, style: theme.textTheme.titleSmall),
                      ]),
                    ),
                    if (children.isNotEmpty) const Divider(),
                  ],
                  ...children,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
