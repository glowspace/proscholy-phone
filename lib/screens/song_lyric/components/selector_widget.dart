import 'package:flutter/material.dart';
import 'package:zpevnik/theme.dart';

class SelectorWidget extends StatefulWidget {
  final Function(int p1) onSelected;
  final List<Widget> options;
  final int selected;

  const SelectorWidget({
    Key key,
    @required this.onSelected,
    @required this.options,
    this.selected,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectorWidgetState(selected);
}

class _SelectorWidgetState extends State<SelectorWidget> {
  int _selected;

  _SelectorWidgetState(int selected) : _selected = selected ?? 0;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: AppTheme.of(context).disabledColor, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: List.generate(
            widget.options.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() => _selected = index);

                if (widget.onSelected != null) widget.onSelected(index);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: index == _selected ? AppTheme.of(context).activeColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(8)),
                child: SizedBox(
                  height: 28,
                  width: 40,
                  child: widget.options[index],
                ),
              ),
            ),
          ),
        ),
      );
}
