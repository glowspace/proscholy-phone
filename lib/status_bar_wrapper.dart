import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zpevnik/theme.dart';

class StatusBarWrapper extends StatelessWidget {
  final Widget child;
  final Color color;

  StatusBarWrapper({this.child, this.color});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: appTheme.brightness,
        statusBarIconBrightness:
            appTheme.brightness == Brightness.light ? Brightness.dark : Brightness.light,
        statusBarColor: color == null ? appTheme.backgroundColor : color,
        systemNavigationBarColor: appTheme.backgroundColor,
      ),
      child: child,
    );
  }
}
