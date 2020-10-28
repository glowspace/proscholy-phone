import 'dart:io';

import 'package:flutter/material.dart';

mixin PlatformWidgetMixin on StatelessWidget {
  Widget build(BuildContext context) {
    if (Platform.isIOS)
      return iOSWidget(context);
    else if (Platform.isAndroid) return iOSWidget(context);

    return Container();
  }

  Widget iOSWidget(BuildContext context);

  Widget androidWidget(BuildContext context);
}

mixin PlatformStateMixin<T extends StatefulWidget> on State<T> {
  Widget build(BuildContext context) {
    if (Platform.isIOS)
      return iOSWidget(context);
    else if (Platform.isAndroid) return iOSWidget(context);

    return Container();
  }

  Widget iOSWidget(BuildContext context);

  Widget androidWidget(BuildContext context);
}
