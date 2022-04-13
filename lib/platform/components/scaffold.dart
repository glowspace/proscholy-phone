import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/platform/mixin.dart';
import 'package:zpevnik/providers/fullscreen.dart';
import 'package:zpevnik/screens/components/invisible_app_bar.dart';
import 'package:zpevnik/theme.dart';

class PlatformScaffold extends StatelessWidget with PlatformMixin {
  final Widget body;

  final String? title;
  final Color? navigationBarColor;
  final Color? navigationBarTextColor;

  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;

  final bool canBeFullscreen;

  const PlatformScaffold({
    Key? key,
    required this.body,
    this.title,
    this.navigationBarColor,
    this.navigationBarTextColor,
    this.leading,
    this.middle,
    this.trailing,
    this.canBeFullscreen = false,
  }) : super(key: key);

  @override
  Widget buildAndroid(BuildContext context) {
    final appTheme = AppTheme.of(context);

    final systemOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: navigationBarColor ?? appTheme.backgroundColor,
      systemNavigationBarColor: appTheme.backgroundColor,
      statusBarBrightness: appTheme.brightness,
      statusBarIconBrightness: appTheme.brightness == Brightness.light ? Brightness.dark : Brightness.light,
    );

    final navBar = AppBar(
      automaticallyImplyLeading: middle == null,
      backgroundColor: navigationBarColor,
      iconTheme: IconThemeData(color: navigationBarTextColor ?? appTheme.iconColor),
      leading: _wrappedLeading,
      systemOverlayStyle: systemOverlayStyle,
      title: middle ??
          FittedBox(
            child: Text(
              title ?? '',
              style: appTheme.navBarTitleTextStyle?.copyWith(color: navigationBarTextColor),
            ),
          ),
      actions: trailing == null ? null : [trailing!],
      titleSpacing: 0,
    );

    return Scaffold(
      body: SafeArea(child: body),
      appBar: _showNavBar(context) ? navBar : InvisibleAppBar(systemOverlayStyle: systemOverlayStyle),
    );
  }

  @override
  Widget buildIos(BuildContext context) {
    final appTheme = AppTheme.of(context);

    // there is hardcoded 6px padding in CupertinoNavigationBar, this will remove it using OverflowBox
    final width = MediaQuery.of(context).size.width;
    Widget? middleWrapped;
    if (middle != null) middleWrapped = OverflowBox(minWidth: width, maxWidth: width, child: middle);

    final navBar = CupertinoNavigationBar(
      automaticallyImplyLeading: middle == null,
      backgroundColor: navigationBarColor,
      leading: _wrappedLeading,
      middle: middleWrapped ??
          FittedBox(
            child: Text(
              title ?? '',
              style: appTheme.navBarTitleTextStyle?.copyWith(color: navigationBarTextColor),
            ),
          ),
      trailing: trailing,
      transitionBetweenRoutes: middle == null, // needed because of search widget
    );

    final scaffold = CupertinoPageScaffold(
      child: SafeArea(child: body),
      navigationBar: _showNavBar(context) ? navBar : null,
    );

    if (navigationBarTextColor == null) return scaffold;

    return CupertinoTheme(
      child: scaffold,
      data: appTheme.cupertinoTheme.copyWith(textTheme: CupertinoTextThemeData(primaryColor: navigationBarTextColor!)),
    );
  }

  Widget? get _wrappedLeading {
    if (leading == null) return null;

    return Align(widthFactor: 1.0, alignment: Alignment.center, child: leading);
  }

  bool _showNavBar(BuildContext context) {
    final fullScreenProvider = context.watch<FullScreenProvider?>();

    return (middle != null || title != null) && !(canBeFullscreen && (fullScreenProvider?.isFullScreen ?? false));
  }
}
