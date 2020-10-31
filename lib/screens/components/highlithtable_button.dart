import 'package:flutter/material.dart';

class HighlightableButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final Color highlightedColor;
  final Function() onPressed;
  final EdgeInsets padding;

  const HighlightableButton({Key key, this.icon, this.color, this.highlightedColor, this.onPressed, this.padding})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _HighlightableButtonState();
}

class _HighlightableButtonState extends State<HighlightableButton> {
  bool _highlighted;

  @override
  void initState() {
    super.initState();

    _highlighted = false;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onPanDown: (_) => setState(() => _highlighted = true),
        onPanCancel: () => setState(() => _highlighted = false),
        onTap: widget.onPressed,
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: widget.padding,
          child: Icon(
            widget.icon,
            color: _highlighted ? widget.highlightedColor : widget.color,
          ),
        ),
      );
}
