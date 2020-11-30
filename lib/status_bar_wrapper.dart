import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zpevnik/theme.dart';

class StatusBarWrapper extends StatelessWidget {
  final Widget child;

  StatusBarWrapper({this.child});

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarBrightness: AppThemeNew.of(context).brightness,
          statusBarColor: AppThemeNew.of(context).backgroundColor,
        ),
        child: child,
      );
}
