import 'dart:io';

import 'package:flutter/material.dart';

mixin PlatformMixin {
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return buildWrapper(context, buildAndroid);
    } else if (Platform.isIOS) {
      return buildWrapper(context, buildIos);
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  Widget buildWrapper(BuildContext context, Widget Function(BuildContext) builder) => builder(context);

  Widget buildAndroid(BuildContext context);

  Widget buildIos(BuildContext context);
}
