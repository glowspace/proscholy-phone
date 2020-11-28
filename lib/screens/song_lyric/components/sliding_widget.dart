import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/scroll_provider.dart';
import 'package:zpevnik/screens/components/custom_icon_button.dart';
import 'package:zpevnik/theme.dart';

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
  Widget build(BuildContext context) => Transform.translate(
        offset: Offset(1, 0), // just to hide right border
        child: Container(
          padding: EdgeInsets.only(left: kDefaultPadding / 2),
          decoration: BoxDecoration(
            color: AppThemeNew.of(context).backgroundColor,
            border: Border.all(color: AppTheme.shared.borderColor(context)),
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(100), // big enough number, so it's always full circular
            ),
          ),
          child: Row(children: _options(context)),
        ),
      );

  List<Widget> _options(BuildContext context) => [
        _collapseable(
            context,
            CustomIconButton(
              onPressed: widget.showSettings,
              icon: Icon(Icons.tune),
            ),
            _collapseAnimation),
        _collapseable(
            context,
            CustomIconButton(
              onPressed: widget.showExternals,
              icon: Icon(Icons.headset),
            ),
            _collapseAnimation),
        // _collapseable(context, Icon(Icons.add), _collapseAnimation),
        // _collapseable(context, Icon(Icons.remove), _collapseAnimation),
        Consumer<ScrollProvider>(
          builder: (context, provider, _) => _collapseable(
              context,
              CustomIconButton(
                onPressed: provider.canScroll ? provider.toggleScroll : null,
                icon: Icon(provider.scrolling ? Icons.stop : Icons.arrow_downward),
              ),
              _collapseAnimation),
        ),
        CustomIconButton(
          onPressed: _toggleCollapse,
          icon: Transform.rotate(
            angle: _collapseAnimation.value * pi,
            child: Icon(Icons.arrow_back),
          ),
        ),
      ];

  Widget _collapseable(BuildContext context, Widget child, Animation<double> animation) => SizeTransition(
        sizeFactor: animation,
        axis: Axis.horizontal,
        child: Opacity(opacity: animation.value, child: child),
      );

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
