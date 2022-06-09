import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class CollapseableWidget extends StatefulWidget {
  final Widget child;
  final ValueNotifier<bool> collapsed;
  final bool inverted;

  final Axis collapseAxis;

  const CollapseableWidget({
    Key? key,
    required this.child,
    required this.collapsed,
    this.collapseAxis = Axis.vertical,
    this.inverted = false,
  }) : super(key: key);

  @override
  _CollapseableWidgetState createState() => _CollapseableWidgetState();
}

class _CollapseableWidgetState extends State<CollapseableWidget> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: kDefaultAnimationDuration, vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)..addListener(() => setState(() {}));

    _controller.value = collapsed ? 0 : 1;

    widget.collapsed.addListener(_update);
  }

  @override
  void dispose() {
    _controller.dispose();

    widget.collapsed.removeListener(_update);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(sizeFactor: _animation, axis: widget.collapseAxis, child: widget.child);
  }

  void _update() {
    _controller.animateTo(collapsed ? 0 : 1);
  }

  bool get collapsed => widget.inverted ? !widget.collapsed.value : widget.collapsed.value;
}
