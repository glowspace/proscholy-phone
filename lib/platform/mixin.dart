import 'package:flutter/material.dart';

mixin PlatformMixin {
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        return buildWrapper(context, buildAndroid);
      case TargetPlatform.iOS:
        return buildWrapper(context, buildIos);
      default:
        return Container();
    }
  }

  Widget buildWrapper(BuildContext context, Widget Function(BuildContext) builder) => builder(context);

  Widget buildAndroid(BuildContext context);

  Widget buildIos(BuildContext context);
}
