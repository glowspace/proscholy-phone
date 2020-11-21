import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';

class HighlightableRow extends StatefulWidget {
  final String title;
  final IconData icon;
  final Function() onPressed;
  final EdgeInsets padding;

  const HighlightableRow({Key key, this.title, this.icon, this.onPressed, this.padding}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HighlightableRowState();
}

class _HighlightableRowState extends State<HighlightableRow> {
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
        onPanEnd: (_) => setState(() => _highlighted = false),
        onTap: widget.onPressed,
        behavior: HitTestBehavior.translucent,
        child: Container(
          color: _highlighted ? AppTheme.shared.highlightColor(context) : null,
          padding: widget.padding,
          child: Opacity(
            opacity: _highlighted ? 0.75 : 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Row(children: [
                Container(padding: EdgeInsets.only(right: kDefaultPadding / 2), child: Icon(widget.icon)),
                Text(widget.title),
              ]),
            ),
          ),
        ),
      );
}
