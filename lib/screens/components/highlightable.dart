import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';

class Highlightable extends StatefulWidget {
  final Widget child;
  final Function()? onPressed;
  final Function()? onLongPressed;
  final EdgeInsets padding;
  final GlobalKey? highlightableChildKey;

  final Color color;

  const Highlightable({
    Key? key,
    required this.child,
    this.onPressed,
    this.onLongPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
    this.highlightableChildKey,
    this.color = Colors.transparent,
  }) : super(key: key);

  @override
  _HighlightableState createState() => _HighlightableState();
}

class _HighlightableState extends State<Highlightable> {
  bool _isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    // if child is icon highlight will change icon color, otherwise it will change background of the child
    final isIcon = widget.child is Icon;

    final appTheme = AppTheme.of(context);
    final color = _isHighlighted
        ? appTheme.highlightColor
        : (isIcon
            ? (widget.onPressed == null
                ? appTheme.disabledColor
                : (widget.color == Colors.transparent ? appTheme.iconColor : widget.color))
            : widget.color);

    final child = isIcon ? IconTheme(data: IconThemeData(color: color), child: widget.child) : widget.child;

    return Container(
      color: isIcon ? null : color,
      padding: widget.padding,
      child: GestureDetector(
        onPanDown: (details) => _setHightlight(!_containsChild(details)),
        onPanCancel: () => _setHightlight(false),
        onPanEnd: (_) => _setHightlight(false),
        onTap: widget.onPressed,
        onLongPress: widget.onLongPressed,
        behavior: HitTestBehavior.translucent,
        child: child,
      ),
    );
  }

  bool _containsChild(DragDownDetails details) {
    final RenderBox? renderBox = widget.highlightableChildKey?.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      final topLeftCorner = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      final rectangle = topLeftCorner & size;

      return rectangle.contains(details.globalPosition);
    }

    return false;
  }

  void _setHightlight(bool isHighlighted) {
    if (widget.onPressed == null) return;
    setState(() => _isHighlighted = isHighlighted);
  }
}
