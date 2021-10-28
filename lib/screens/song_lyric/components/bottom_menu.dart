import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/scroll.dart';
import 'package:zpevnik/screens/components/collapseable.dart';
import 'package:zpevnik/screens/components/highlightable.dart';
import 'package:zpevnik/screens/components/rotateable.dart';
import 'package:zpevnik/screens/utils/updateable.dart';
import 'package:zpevnik/theme.dart';

class BottomMenu extends StatefulWidget {
  final Function() showSettings;
  final Function() showExternals;
  final bool hasExternals;

  final ScrollProvider scrollProvider;

  BottomMenu({
    Key? key,
    required this.showSettings,
    required this.showExternals,
    required this.hasExternals,
    required this.scrollProvider,
  }) : super(key: key);

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> with Updateable {
  final _collapsed = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      transform: Matrix4.translationValues(1, 0, 0), // just to hide right border
      padding: EdgeInsets.only(left: kDefaultPadding),
      decoration: BoxDecoration(
        color: appTheme.backgroundColor,
        border: Border.all(color: appTheme.borderColor),
        borderRadius: BorderRadius.horizontal(left: Radius.circular(100)),
      ),
      child: Row(children: _options(context)),
    );
  }

  List<Widget> _options(BuildContext context) {
    final padding = EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding);

    return [
      CollapseableWidget(
        collapsed: _collapsed,
        collapseAxis: Axis.horizontal,
        child: Row(children: [
          Highlightable(child: Icon(Icons.tune), padding: padding, onPressed: widget.showSettings),
          if (widget.hasExternals)
            Highlightable(child: Icon(Icons.headset), padding: padding, onPressed: widget.showExternals),
          CollapseableWidget(
            collapsed: widget.scrollProvider.isScrolling,
            collapseAxis: Axis.horizontal,
            inverted: true,
            child: Row(children: [
              Highlightable(child: Icon(Icons.add), padding: padding, onPressed: widget.scrollProvider.faster),
              Highlightable(child: Icon(Icons.remove), padding: padding, onPressed: widget.scrollProvider.slower),
            ]),
          ),
          Highlightable(
            child: Icon(widget.scrollProvider.isScrolling.value ? Icons.stop : Icons.arrow_downward),
            padding: padding,
            onPressed: widget.scrollProvider.canScroll ? widget.scrollProvider.toggleScroll : null,
          ),
        ]),
      ),
      RotateableWidget(
        rotated: _collapsed,
        child: Highlightable(
          child: Icon(Icons.arrow_back),
          padding: padding,
          onPressed: _toggleCollapsed,
        ),
      ),
    ];
  }

  void _toggleCollapsed() {
    _collapsed.value = !_collapsed.value;
  }

  @override
  List<Listenable> get listenables => [widget.scrollProvider.isScrolling, widget.scrollProvider.controller];
}
