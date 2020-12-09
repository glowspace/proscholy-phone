import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';

class HighlightableRow extends StatefulWidget {
  final Widget child;
  final Color color;
  final Color highlightColor;
  final EdgeInsets padding;
  final Function() onPressed;

  const HighlightableRow({
    Key key,
    @required this.child,
    this.color,
    this.highlightColor,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HighlightableRowState();
}

class _HighlightableRowState extends State<HighlightableRow> {
  bool _isHighlighted;

  @override
  void initState() {
    super.initState();

    _isHighlighted = false;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => setState(() => _isHighlighted = true),
        onTapCancel: () => setState(() => _isHighlighted = false),
        onTapUp: (_) => setState(() => _isHighlighted = false),
        onTap: widget.onPressed,
        behavior: HitTestBehavior.translucent,
        child: Container(
          color: widget.onPressed == null ? AppThemeNew.of(context).disabledColor : _color,
          padding: widget.padding,
          child: widget.child,
        ),
      );

  Color get _color => _isHighlighted
      ? (widget.highlightColor == null
          ? (widget.color == null ? AppThemeNew.of(context).highlightColor : widget.color.withAlpha(0x80))
          : widget.highlightColor)
      : widget.color;
}
