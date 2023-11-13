import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class SelectorWidget<T> extends StatelessWidget {
  final String title;

  final Function(T) onSelected;
  final List<ButtonSegment<T>> segments;
  final T selected;

  final bool isEnabled;

  final EdgeInsets padding;

  const SelectorWidget({
    super.key,
    required this.title,
    required this.onSelected,
    required this.segments,
    required this.selected,
    this.isEnabled = true,
    this.padding = const EdgeInsets.all(kDefaultPadding),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: padding,
      child: Row(children: [
        Expanded(
          child: Text(title, style: textTheme.bodyMedium?.copyWith(color: isEnabled ? null : theme.disabledColor)),
        ),
        SegmentedButton<T>(
          style: const ButtonStyle(
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          segments: segments,
          selected: {selected},
          onSelectionChanged: isEnabled ? (selected) => onSelected(selected.first) : null,
          showSelectedIcon: false,
        ),
      ]),
    );
  }
}
