import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/scroll_provider.dart';

class SlidingWidget extends StatefulWidget {
  final Function() showSettings;
  final Function() showExternals;

  const SlidingWidget({Key key, this.showSettings, this.showExternals}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SlidingWidgetState();
}

class _SlidingWidgetState extends State<SlidingWidget> with SingleTickerProviderStateMixin {
  Animation<double> _collapseAnimation;
  AnimationController _collapseController;

  bool _collapsed;

  @override
  void initState() {
    super.initState();

    _collapsed = false;

    _collapseController =
        AnimationController(duration: const Duration(milliseconds: kDefaultAnimationTime), vsync: this);
    _collapseAnimation = Tween<double>(begin: 1, end: 0).animate(_collapseController)
      ..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(left: kDefaultPadding / 3),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(100), // big enough number, so it's always full circular
          ),
        ),
        child: Row(
          children: _options(context),
        ),
      );

  List<Widget> _options(BuildContext context) => [
        GestureDetector(
            onTap: widget.showSettings, child: _collapseable(context, Icon(Icons.tune), _collapseAnimation)),
        GestureDetector(
            onTap: widget.showExternals, child: _collapseable(context, Icon(Icons.headset), _collapseAnimation)),
        // _collapseable(context, Icon(Icons.add), _collapseAnimation),
        // _collapseable(context, Icon(Icons.remove), _collapseAnimation),
        Consumer<ScrollProvider>(
          builder: (context, provider, _) => GestureDetector(
            onTap: provider.toggleScroll,
            child: _collapseable(
                context, Icon(provider.scrolling ? Icons.stop : Icons.arrow_downward), _collapseAnimation),
          ),
        ),
        GestureDetector(
          onTap: _toggleCollapse,
          child: _wrapped(
            context,
            Transform.rotate(
              angle: _collapseAnimation.value * pi,
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
      ];

  Widget _collapseable(BuildContext context, Widget child, Animation<double> animation) => SizeTransition(
        sizeFactor: animation,
        axis: Axis.horizontal,
        child: Opacity(opacity: animation.value, child: _wrapped(context, child)),
      );

  Widget _wrapped(BuildContext context, Widget child) => Container(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 4, horizontal: kDefaultPadding / 3), child: child);

  void _toggleCollapse() {
    _collapsed ? _collapseController.reverse() : _collapseController.forward();
    _collapsed = !_collapsed;
  }

  @override
  void dispose() {
    _collapseController.dispose();

    super.dispose();
  }
}
