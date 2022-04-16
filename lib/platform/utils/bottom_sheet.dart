import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:zpevnik/theme.dart';

Future<T?> showPlatformBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  double? height,
}) {
  final appTheme = AppTheme.of(context);

  const shape = RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15)));

  FocusScope.of(context).unfocus();

  if (Platform.isIOS) {
    return showCupertinoModalBottomSheet(
      context: context,
      shape: shape,
      builder: (context) => Container(
        height: height,
        color: appTheme.fillColor,
        child: builder(context),
      ),
      useRootNavigator: true,
    );
  } else {
    return showMaterialModalBottomSheet(
      context: context,
      shape: shape,
      builder: (context) => Container(
        height: height,
        color: appTheme.fillColor,
        child: builder(context),
      ),
      useRootNavigator: true,
    );
  }
}
