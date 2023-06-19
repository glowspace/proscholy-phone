import 'package:flutter/cupertino.dart';

class SelectorWidget extends StatelessWidget {
  final Function(int) onSelected;
  final List<Widget> options;
  final int selected;
  final double? width;

  const SelectorWidget({
    super.key,
    required this.onSelected,
    this.options = const [],
    this.selected = 0,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: CupertinoSlidingSegmentedControl(
        children: options.asMap(),
        groupValue: selected,
        onValueChanged: _selectedChanged,
      ),
    );
  }

  void _selectedChanged(int? index) {
    if (index == null) return;

    onSelected(index);
  }
}
