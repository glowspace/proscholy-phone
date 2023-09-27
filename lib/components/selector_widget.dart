import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class SelectorWidget extends StatelessWidget {
  final String title;

  final Function(int) onSelected;
  final List<ButtonSegment<int>> segments;
  final int selected;

  final EdgeInsets padding;

  const SelectorWidget({
    super.key,
    required this.title,
    required this.onSelected,
    required this.segments,
    this.selected = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: kDefaultPadding),
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: padding,
      child: Row(children: [
        Expanded(child: Text(title, style: textTheme.bodyMedium)),
        SegmentedButton(
          style: const ButtonStyle(
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          segments: segments,
          selected: {selected},
          onSelectionChanged: (selected) => onSelected(selected.first),
          showSelectedIcon: false,
        ),
      ]),
    );
  }
}
