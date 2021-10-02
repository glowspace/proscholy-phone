import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:zpevnik/theme.dart';

void showPlatformBottomSheet({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  required double height,
}) {
  final appTheme = AppTheme.of(context);

  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15)));

  FocusScope.of(context).unfocus();

  if (appTheme.platform == TargetPlatform.iOS)
    showCupertinoModalBottomSheet(
      context: context,
      shape: shape,
      builder: (context) => Container(
        child: SizedBox(height: height, child: builder(context)),
        color: appTheme.fillColor,
      ),
      useRootNavigator: true,
    );
  else
    showMaterialModalBottomSheet(
      context: context,
      shape: shape,
      builder: (context) => SizedBox(height: height, child: builder(context)),
      useRootNavigator: true,
    );
}
