import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';

class HighlightableButton extends StatefulWidget {
  final Widget icon;
  final Color color;
  final Color highlightColor;
  final EdgeInsets padding;
  final Function() onPressed;

  const HighlightableButton({
    Key key,
    @required this.icon,
    this.color,
    this.highlightColor,
    this.padding = const EdgeInsets.all(kDefaultPadding),
    this.onPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HighlightableButtonState();
}

class _HighlightableButtonState extends State<HighlightableButton> {
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
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            padding: widget.padding,
            child: IconTheme(
              data: IconThemeData(
                color: widget.onPressed == null ? AppTheme.of(context).disabledColor : _iconColor,
              ),
              child: widget.icon,
            ),
          ),
        ),
      );

  Color get _color => widget.color == null ? AppTheme.of(context).iconColor : widget.color;

  Color get _iconColor => _isHighlighted ? _highlightColor : _color;

  Color get _highlightColor => widget.highlightColor == null ? _color.withAlpha(0x80) : widget.highlightColor;
}
