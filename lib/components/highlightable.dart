import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class Highlightable extends StatefulWidget {
  final Widget child;

  final Function()? onTap;
  final Function()? onLongPress;

  final Color? color;
  final Color? highlightColor;

  final EdgeInsets? padding;

  final bool highlightBackground;

  final bool isDisabled;

  // to ignore highlight when highlightable child should be highlighted
  final List<GlobalKey>? highlightableChildKeys;

  const Highlightable({
    Key? key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.color,
    this.highlightColor,
    this.padding,
    this.highlightBackground = false,
    this.isDisabled = false,
    this.highlightableChildKeys,
  }) : super(key: key);

  @override
  State<Highlightable> createState() => _HighlightableState();
}

class _HighlightableState extends State<Highlightable> with SingleTickerProviderStateMixin {
  bool _isHighlighted = false;

  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: kDefaultAnimationDuration,
      value: widget.isDisabled ? 0.25 : 1,
      lowerBound: 0.25,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(Highlightable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isDisabled != oldWidget.isDisabled) {
      _animationController.animateTo(widget.isDisabled ? 0.25 : 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color? color = widget.color ?? Colors.transparent;
    Color? highlightColor = widget.highlightColor;

    if (widget.highlightBackground) {
      highlightColor ??= theme.highlightColor;
    } else {
      highlightColor ??= Colors.white;
    }

    if (widget.highlightBackground && _isHighlighted) color = Color.alphaBlend(highlightColor, color);

    if (widget.highlightBackground && widget.isDisabled) color = theme.disabledColor;

    Widget child = Container(
      color: color,
      padding: widget.padding,
      child: widget.child,
    );

    if (!widget.highlightBackground) {
      child = AnimatedBuilder(
        animation: _animationController,
        builder: (_, child) => ColorFiltered(
          colorFilter: ColorFilter.mode(
            highlightColor!.withOpacity(!widget.isDisabled && _isHighlighted ? 0.5 : _animationController.value),
            BlendMode.modulate,
          ),
          child: child,
        ),
        child: child,
      );
    }

    return GestureDetector(
      onPanDown: (details) => setState(() => _isHighlighted = !_containsChild(details)),
      onPanEnd: (_) => setState(() => _isHighlighted = false),
      // delayed, so the highlight is visible when fast tap happens
      onPanCancel: () => setState(() => _isHighlighted = false),
      onTap: widget.isDisabled ? null : widget.onTap,
      onLongPress: widget.onLongPress,
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }

  bool _containsChild(DragDownDetails details) {
    if (widget.highlightableChildKeys == null) return false;

    for (final key in widget.highlightableChildKeys!) {
      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        final rectangle = renderBox.localToGlobal(Offset.zero) & renderBox.size;

        if (rectangle.contains(details.globalPosition)) return true;
      }
    }

    return false;
  }
}
