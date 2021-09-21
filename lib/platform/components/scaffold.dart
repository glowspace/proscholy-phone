import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/platform/mixin.dart';
import 'package:zpevnik/providers/fullscreen.dart';
import 'package:zpevnik/theme.dart';

class PlatformScaffold extends StatelessWidget with PlatformMixin {
  final Widget body;

  final String? title;
  final Color? navigationBarColor;

  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;

  const PlatformScaffold({
    Key? key,
    required this.body,
    this.title,
    this.navigationBarColor,
    this.leading,
    this.middle,
    this.trailing,
  }) : super(key: key);

  @override
  Widget buildAndroid(BuildContext context) {
    final appTheme = AppTheme.of(context);

    final navBar = AppBar(
      automaticallyImplyLeading: middle == null,
      backgroundColor: navigationBarColor,
      iconTheme: IconThemeData(color: appTheme.iconColor),
      leading: _wrappedLeading,
      title: middle ?? FittedBox(child: Text(title ?? '', style: appTheme.bodyTextStyle)),
      actions: trailing == null ? null : [trailing!],
      titleSpacing: 0,
    );

    return Scaffold(
      body: SafeArea(child: body),
      appBar: _showNavBar(context) ? navBar : null,
    );
  }

  @override
  Widget buildIos(BuildContext context) {
    // there is hardcoded 6px padding in CupertinoNavigationBar, this will remove it using OverflowBox
    final width = MediaQuery.of(context).size.width;
    Widget? middleWrapped;
    if (middle != null) middleWrapped = OverflowBox(minWidth: width, maxWidth: width, child: middle);

    final navBar = CupertinoNavigationBar(
      automaticallyImplyLeading: middle == null,
      backgroundColor: navigationBarColor,
      leading: _wrappedLeading,
      middle: middleWrapped ?? FittedBox(child: Text(title ?? '')),
      trailing: trailing,
      transitionBetweenRoutes: middle == null, // needed because of search widget
    );

    return CupertinoPageScaffold(
      child: SafeArea(child: body),
      navigationBar: _showNavBar(context) ? navBar : null,
    );
  }

  // @override
  // Widget buildWrapper(BuildContext context, Widget Function(BuildContext) builder) {
  //   final appTheme = AppTheme.of(context);

  //   return AnnotatedRegion<SystemUiOverlayStyle>(
  //     value: SystemUiOverlayStyle(
  //       statusBarColor: navigationBarColor ?? appTheme.backgroundColor,
  //       systemNavigationBarColor: appTheme.backgroundColor,
  //       statusBarBrightness: appTheme.brightness,
  //       statusBarIconBrightness: appTheme.brightness == Brightness.light ? Brightness.dark : Brightness.light,
  //     ),
  //     child: builder(context),
  //   );
  // }

  Widget? get _wrappedLeading {
    if (leading == null) return null;

    return Align(widthFactor: 1.0, alignment: Alignment.center, child: leading);
  }

  bool _showNavBar(BuildContext context) {
    final fullScreenProvider = context.watch<FullScreenProvider?>();

    return (middle != null || title != null) && !(fullScreenProvider?.isFullScreen ?? false);
  }
}
