import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/providers/scroll_provider.dart';
import 'package:zpevnik/screens/components/highlightable_button.dart';
import 'package:zpevnik/theme.dart';

const _collapsedKey = 'collapsed';

class SlidingWidget extends StatefulWidget {
  final Function() showSettings;
  final Function() showExternals;
  final ScrollProvider scrollProvider;

  const SlidingWidget({Key key, this.showSettings, this.showExternals, this.scrollProvider}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SlidingWidgetState();
}

class _SlidingWidgetState extends State<SlidingWidget> with SingleTickerProviderStateMixin {
  bool _initial;
  ValueNotifier<bool> _collapsed;
  ValueNotifier<bool> _scrollSpeedcollapsed;

  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _initial = DataProvider.shared.prefs.getBool(_collapsedKey) ?? false;
    _collapsed = ValueNotifier(_initial);

    _controller = AnimationController(duration: const Duration(milliseconds: kDefaultAnimationTime), vsync: this);
    _animation = Tween<double>(begin: _initial ? 0 : 1, end: _initial ? 1 : 0).animate(_controller)
      ..addListener(() => setState(() {}));

    _scrollSpeedcollapsed = ValueNotifier(true);

    widget.scrollProvider.scrolling.addListener(_scrollingChanged);
  }

  @override
  Widget build(BuildContext context) => Transform.translate(
        offset: Offset(1, 0), // just to hide right border
        child: Container(
          padding: EdgeInsets.only(left: kDefaultPadding),
          decoration: BoxDecoration(
            color: AppTheme.of(context).backgroundColor,
            border: Border.all(color: AppTheme.of(context).borderColor),
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(100), // big enough number, so it's always full circular
            ),
          ),
          child: Row(children: _options(context)),
        ),
      );

  List<Widget> _options(BuildContext context) {
    final padding = EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding);

    return [
      _CollapseableWidget(collapsed: _collapsed, children: [
        HighlightableButton(icon: Icon(Icons.tune), padding: padding, onPressed: widget.showSettings),
        HighlightableButton(icon: Icon(Icons.headset), padding: padding, onPressed: widget.showExternals),
        _CollapseableWidget(collapsed: _scrollSpeedcollapsed, children: [
          HighlightableButton(icon: Icon(Icons.add), padding: padding, onPressed: widget.scrollProvider.faster),
          HighlightableButton(icon: Icon(Icons.remove), padding: padding, onPressed: widget.scrollProvider.slower),
        ]),
        HighlightableButton(
          icon: Icon(widget.scrollProvider.scrolling.value ? Icons.stop : Icons.arrow_downward),
          padding: padding,
          onPressed: widget.scrollProvider.canScroll ? widget.scrollProvider.toggleScroll : null,
        ),
      ]),
      HighlightableButton(
        icon: Transform.rotate(angle: _animation.value * pi, child: Icon(Icons.arrow_back)),
        padding: padding,
        onPressed: _toggleCollapsed,
      ),
    ];
  }

  void _scrollingChanged() => setState(() => _scrollSpeedcollapsed.value = !widget.scrollProvider.scrolling.value);

  void _toggleCollapsed() {
    _collapsed.value
        ? (_initial ? _controller.forward() : _controller.reverse())
        : (_initial ? _controller.reverse() : _controller.forward());
    _collapsed.value = !_collapsed.value;

    DataProvider.shared.prefs.setBool(_collapsedKey, _collapsed.value);
  }

  @override
  void dispose() {
    widget.scrollProvider.scrolling.removeListener(_scrollingChanged);

    super.dispose();
  }
}

class _CollapseableWidget extends StatefulWidget {
  final ValueNotifier<bool> collapsed;
  final List<Widget> children;

  const _CollapseableWidget({
    Key key,
    @required this.collapsed,
    this.children,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CollapseableWidgetState();
}

class _CollapseableWidgetState extends State<_CollapseableWidget> with SingleTickerProviderStateMixin {
  bool _initial;
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _initial = widget.collapsed.value;

    _controller = AnimationController(duration: const Duration(milliseconds: kDefaultAnimationTime), vsync: this);
    _animation = Tween<double>(begin: _initial ? 0 : 1, end: _initial ? 1 : 0).animate(_controller)
      ..addListener(() => setState(() {}));

    widget.collapsed.addListener(_update);
  }

  @override
  Widget build(BuildContext context) => SizeTransition(
        sizeFactor: _animation,
        axis: Axis.horizontal,
        child: Opacity(opacity: _animation.value, child: Row(children: widget.children)),
      );

  void _update() => widget.collapsed.value
      ? (_initial ? _controller.reverse() : _controller.forward())
      : (_initial ? _controller.forward() : _controller.reverse());

  @override
  void dispose() {
    widget.collapsed.removeListener(_update);
    _controller.dispose();

    super.dispose();
  }
}
