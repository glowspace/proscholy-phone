import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';

class HighlightableRow extends StatefulWidget {
  final Widget child;
  final Color color;
  final Color highlightColor;
  final EdgeInsets padding;
  final Function() onPressed;
  // active widgets, which should not be block by gesture detector
  final Widget prefix;
  final Widget suffix;

  const HighlightableRow({
    Key key,
    @required this.child,
    this.color,
    this.highlightColor,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding),
    this.prefix,
    this.suffix,
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
  Widget build(BuildContext context) => Container(
        // color must be set in box decoration here, otherwise it conflicts with gesture detector defined lower
        decoration: BoxDecoration(color: widget.onPressed == null ? AppTheme.of(context).disabledColor : _color),
        padding: widget.padding,
        child: Row(children: [
          if (widget.prefix != null) Container(padding: EdgeInsets.only(right: kDefaultPadding), child: widget.prefix),
          Expanded(
            child: GestureDetector(
              onPanDown: (_) => setState(() => _isHighlighted = true),
              onPanCancel: () => setState(() => _isHighlighted = false),
              onPanEnd: (_) => setState(() => _isHighlighted = false),
              onTap: widget.onPressed,
              behavior: HitTestBehavior.translucent,
              child: Container(child: widget.child),
            ),
          ),
          if (widget.suffix != null)
            Container(
              padding: EdgeInsets.only(left: kDefaultPadding),
              child: widget.suffix,
            )
        ]),
      );

  Color get _color => _isHighlighted
      ? (widget.highlightColor == null
          ? (widget.color == null ? AppTheme.of(context).highlightColor : widget.color.withAlpha(0x80))
          : widget.highlightColor)
      : widget.color;
}
