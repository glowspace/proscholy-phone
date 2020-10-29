import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

mixin PlatformWidgetMixin on StatelessWidget {
  Widget build(BuildContext context) {
    if (Platform.isIOS)
      return androidWidget(context);
    else if (Platform.isAndroid) return androidWidget(context);

    return Container();
  }

  Widget iOSWidget(BuildContext context);

  Widget androidWidget(BuildContext context);
}

mixin PlatformStateMixin<T extends StatefulWidget> on State<T> {
  Widget build(BuildContext context) {
    if (Platform.isIOS)
      return androidWidget(context);
    else if (Platform.isAndroid) return androidWidget(context);

    return Container();
  }

  Widget iOSWidget(BuildContext context);

  Widget androidWidget(BuildContext context);
}
