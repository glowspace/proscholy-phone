import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

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
    this.padding = const EdgeInsets.symmetric(vertical: kDefaultPadding),
    this.onPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HighlightableButtonState();
}

class _HighlightableButtonState extends State<HighlightableButton> with PlatformStateMixin {
  bool _isHighlighted;

  @override
  void initState() {
    super.initState();

    _isHighlighted = false;
  }

  @override
  Widget androidWidget(BuildContext context) => IconButton(
        onPressed: () => widget.onPressed(),
        icon: widget.icon,
        color: _iconColor,
        padding: widget.padding == null ? EdgeInsets.zero : widget.padding,
        constraints: widget.padding == null ? BoxConstraints() : null,
        visualDensity: VisualDensity.compact,
        splashColor: widget.highlightColor,
        highlightColor: widget.highlightColor,
      );

  @override
  Widget iOSWidget(BuildContext context) => GestureDetector(
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
              )),
        ),
      );

  Color get _color => widget.color == null ? AppTheme.of(context).iconColor : widget.color;

  Color get _iconColor =>
      _isHighlighted ? (widget.highlightColor == null ? _color.withAlpha(0x80) : widget.highlightColor) : _color;
}
