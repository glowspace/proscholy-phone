import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/platform/components/navigation_bar.dart';
import 'package:zpevnik/platform/mixin.dart';
import 'package:zpevnik/providers/fullscreen.dart';
import 'package:zpevnik/theme.dart';

class PlatformScaffold extends StatelessWidget with PlatformMixin {
  final Widget child;

  final PlatformNavigationBar? navigationBar;

  final bool canBeFullscreen;

  const PlatformScaffold({
    Key? key,
    required this.child,
    this.navigationBar,
    this.canBeFullscreen = false,
  }) : super(key: key);

  @override
  Widget buildAndroid(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
      appBar: _showNavBar(context) ? navigationBar : null, //InvisibleAppBar(systemOverlayStyle: systemOverlayStyle),
    );
  }

  @override
  Widget buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(child: child),
      navigationBar: _showNavBar(context) ? navigationBar : null,
    );
  }

  bool _showNavBar(BuildContext context) {
    final fullScreenProvider = context.watch<FullScreenProvider?>();

    return !(canBeFullscreen && (fullScreenProvider?.isFullScreen ?? false));
  }
}
