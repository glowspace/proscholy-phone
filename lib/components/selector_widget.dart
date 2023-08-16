import 'package:flutter/material.dart';

class SelectorWidget extends StatelessWidget {
  final Function(int) onSelected;
  final List<ButtonSegment<int>> segments;
  final int selected;
  final double? width;

  const SelectorWidget({
    super.key,
    required this.onSelected,
    required this.segments,
    this.selected = 0,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: SegmentedButton(
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: segments,
        selected: {selected},
        onSelectionChanged: (selected) => onSelected(selected.first),
        showSelectedIcon: false,
      ),
    );
  }
}
