import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zpevnik/platform/mixin.dart';
import 'package:zpevnik/theme.dart';

class PlatformNavigationBar extends StatefulWidget implements PreferredSizeWidget, ObstructingPreferredSizeWidget {
  final Color? backgroundColor;
  final Color? textColor;

  final String? title;

  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;

  const PlatformNavigationBar({
    Key? key,
    this.backgroundColor,
    this.textColor,
    this.title,
    this.leading,
    this.middle,
    this.trailing,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlatformNavigationBar();

  @override
  Size get preferredSize {
    if (title == null && middle == null) return const Size.square(0);

    return Size.fromHeight(Platform.isIOS ? kMinInteractiveDimensionCupertino : kToolbarHeight);
  }

  @override
  bool shouldFullyObstruct(BuildContext context) {
    final Color backgroundColor = CupertinoDynamicColor.maybeResolve(this.backgroundColor, context) ??
        CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.alpha == 0xFF;
  }
}

class _PlatformNavigationBar extends State<PlatformNavigationBar> with PlatformMixin {
  @override
  Widget buildAndroid(BuildContext context) {
    final appTheme = AppTheme.of(context);

    final systemOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: widget.backgroundColor ?? appTheme.backgroundColor,
      systemNavigationBarColor: appTheme.backgroundColor,
      statusBarBrightness: appTheme.brightness,
      statusBarIconBrightness: appTheme.brightness == Brightness.light ? Brightness.dark : Brightness.light,
    );

    return AppBar(
      automaticallyImplyLeading: widget.middle == null,
      backgroundColor: widget.backgroundColor,
      leading: _wrappedLeading,
      title: widget.middle ??
          FittedBox(
            child: Text(widget.title!, style: appTheme.navBarTitleTextStyle?.copyWith(color: widget.textColor)),
          ),
      actions: [if (widget.trailing != null) widget.trailing!],
      iconTheme: IconThemeData(color: widget.textColor ?? appTheme.iconColor),
      systemOverlayStyle: systemOverlayStyle,
      titleSpacing: 0,
    );
  }

  @override
  Widget buildIos(BuildContext context) {
    final appTheme = AppTheme.of(context);

    // there is hardcoded 6px padding in CupertinoNavigationBar, this will remove it using OverflowBox
    final width = MediaQuery.of(context).size.width;
    Widget? middleWrapped;
    if (widget.middle != null) middleWrapped = OverflowBox(minWidth: width, maxWidth: width, child: widget.middle);

    final navBar = CupertinoNavigationBar(
      automaticallyImplyLeading: widget.middle == null,
      backgroundColor: widget.backgroundColor,
      leading: _wrappedLeading,
      middle: middleWrapped ??
          FittedBox(
            child: Text(widget.title!, style: appTheme.navBarTitleTextStyle?.copyWith(color: widget.textColor)),
          ),
      trailing: widget.trailing,
      transitionBetweenRoutes: widget.middle == null, // needed because of search widget
    );

    if (widget.textColor == null) return navBar;

    return CupertinoTheme(
      data: appTheme.cupertinoTheme.copyWith(textTheme: CupertinoTextThemeData(primaryColor: widget.textColor!)),
      child: navBar,
    );
  }

  @override
  Widget buildWrapper(BuildContext context, Function(BuildContext) builder) {
    if (widget.title == null && widget.middle == null) return Container();

    return builder(context);
  }

  Widget? get _wrappedLeading {
    if (widget.leading == null) return null;

    return Align(widthFactor: 1.0, alignment: Alignment.center, child: widget.leading);
  }
}
