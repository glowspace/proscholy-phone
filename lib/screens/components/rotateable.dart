import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class RotateableWidget extends StatefulWidget {
  final Widget child;
  final ValueNotifier<bool> rotated;

  final double degrees;

  const RotateableWidget({
    Key? key,
    required this.child,
    required this.rotated,
    this.degrees = pi,
  }) : super(key: key);

  @override
  _RotateableWidgetState createState() => _RotateableWidgetState();
}

class _RotateableWidgetState extends State<RotateableWidget> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: kDefaultAnimationTime), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)..addListener(() => setState(() {}));

    _controller.value = widget.rotated.value ? 0 : 1;

    widget.rotated.addListener(_update);
  }

  @override
  void dispose() {
    _controller.dispose();

    widget.rotated.removeListener(_update);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(angle: _animation.value * widget.degrees, child: widget.child);
  }

  void _update() {
    _controller.animateTo(widget.rotated.value ? 0 : 1);
  }
}
