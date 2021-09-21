import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/platform/mixin.dart';
import 'package:zpevnik/theme.dart';

class SelectorWidget extends StatelessWidget with PlatformMixin {
  final Function(int) onSelected;
  final List<Widget> options;
  final int selected;
  final double? width;

  const SelectorWidget({
    Key? key,
    required this.onSelected,
    this.options = const [],
    this.selected = 0,
    this.width,
  }) : super(key: key);

  @override
  Widget buildAndroid(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) => Container(
        decoration: BoxDecoration(color: appTheme.disabledColor, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: List.generate(
            options.length,
            (index) => GestureDetector(
              onTap: () => _selectedChanged(index),
              child: Container(
                  decoration: BoxDecoration(
                    color: index == selected ? appTheme.activeColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox(height: 28, width: constraints.constrainWidth() / 2, child: options[index])),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildIos(BuildContext context) {
    return CupertinoSlidingSegmentedControl(
      children: options.asMap(),
      groupValue: selected,
      onValueChanged: _selectedChanged,
    );
  }

  @override
  Widget buildWrapper(BuildContext context, Widget Function(BuildContext) builder) {
    return SizedBox(child: builder(context), width: width);
  }

  void _selectedChanged(int? index) {
    if (index == null) return;

    onSelected(index);
  }
}
