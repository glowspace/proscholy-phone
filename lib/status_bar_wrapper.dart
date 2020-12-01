import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zpevnik/theme.dart';

class StatusBarWrapper extends StatelessWidget {
  final Widget child;
  final Color color;

  StatusBarWrapper({this.child, this.color});

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarBrightness: AppThemeNew.of(context).brightness,
          statusBarIconBrightness:
              AppThemeNew.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
          statusBarColor: color == null ? AppThemeNew.of(context).backgroundColor : color,
        ),
        child: child,
      );
}
