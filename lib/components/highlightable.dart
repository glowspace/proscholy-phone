import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';

// class Highlightable extends StatefulWidget {
//   final Widget child;

//   final Function()? onTap;
//   final Function()? onLongPress;

//   final Color? color;
//   final EdgeInsets padding;

//   // to ignore highlight when highlightable child should be highlighted
//   final GlobalKey? highlightableChildKey;

//   const Highlightable({
//     Key? key,
//     required this.child,
//     this.onTap,
//     this.onLongPress,
//     this.color,
//     this.padding = const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
//     this.highlightableChildKey,
//   }) : super(key: key);

//   @override
//   State<Highlightable> createState() => _HighlightableState();
// }

// class _HighlightableState extends State<Highlightable> {
//   bool _isHighlighted = false;

//   Timer? _setHighlightTimer;

//   @override
//   void dispose() {
//     _setHighlightTimer?.cancel();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final appTheme = AppTheme.of(context);

//     final isIcon = widget.child is Icon;

//     final Color? color;
//     if (_isHighlighted) {
//       color = appTheme.highlightColor;
//     } else if (widget.color != null) {
//       color = widget.color;
//     } else if (isIcon) {
//       color = appTheme.iconColor;
//     } else {
//       color = null;
//     }

//     final Widget child;
//     if (isIcon) {
//       child = IconTheme(
//         data: IconThemeData(color: color),
//         child: widget.child,
//       );
//     } else {
//       child = widget.child;
//     }

//     return GestureDetector(
//       onPanDown: (details) => setState(() => _isHighlighted = !_containsChild(details)),
//       onPanEnd: (_) => setState(() => _isHighlighted = false),
//       // delayed, so the highlight is visible when fast tap happens
//       onPanCancel: () =>
//           _setHighlightTimer = Timer(const Duration(milliseconds: 20), () => setState(() => _isHighlighted = false)),
//       onTap: widget.onTap,
//       onLongPress: widget.onLongPress,
//       behavior: HitTestBehavior.translucent,
//       child: Container(
//         color: isIcon ? null : color,
//         padding: widget.padding,
//         child: child,
//       ),
//     );
//   }

//   bool _containsChild(DragDownDetails details) {
//     final RenderBox? renderBox = widget.highlightableChildKey?.currentContext?.findRenderObject() as RenderBox?;

//     if (renderBox != null) {
//       final rectangle = renderBox.localToGlobal(Offset.zero) & renderBox.size;

//       return rectangle.contains(details.globalPosition);
//     }

//     return false;
//   }
// }

class Highlightable extends StatefulWidget {
  final Widget child;

  final Function()? onTap;
  final Function()? onLongPress;

  final Color? color;

  // to ignore highlight when highlightable child should be highlighted
  final GlobalKey? highlightableChildKey;

  const Highlightable({
    Key? key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.color,
    this.highlightableChildKey,
  }) : super(key: key);

  @override
  State<Highlightable> createState() => _HighlightableState();
}

class _HighlightableState extends State<Highlightable> {
  bool _isHighlighted = false;

  Timer? _setHighlightTimer;

  @override
  void dispose() {
    _setHighlightTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) => setState(() => _isHighlighted = !_containsChild(details)),
      onPanEnd: (_) => setState(() => _isHighlighted = false),
      // delayed, so the highlight is visible when fast tap happens
      onPanCancel: () =>
          _setHighlightTimer = Timer(const Duration(milliseconds: 20), () => setState(() => _isHighlighted = false)),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      behavior: HitTestBehavior.translucent,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.white.withOpacity(_isHighlighted ? 0.5 : 1), BlendMode.modulate),
        child: widget.child,
      ),
    );
  }

  bool _containsChild(DragDownDetails details) {
    final RenderBox? renderBox = widget.highlightableChildKey?.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      final rectangle = renderBox.localToGlobal(Offset.zero) & renderBox.size;

      return rectangle.contains(details.globalPosition);
    }

    return false;
  }
}
