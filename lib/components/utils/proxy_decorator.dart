import 'dart:ui';

import 'package:flutter/material.dart';

// to make the background of reordering row transparent
Widget transparentBackgroundProxyDecorator(Widget child, int index, Animation animation) {
  return AnimatedBuilder(
    animation: animation,
    builder: (_, child) => Material(
      elevation: lerpDouble(0, 6, Curves.easeInOut.transform(animation.value))!,
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: child,
    ),
    child: child,
  );
}
