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
          statusBarBrightness: AppTheme.of(context).brightness,
          statusBarIconBrightness:
              AppTheme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
          statusBarColor: color == null ? AppTheme.of(context).backgroundColor : color,
        ),
        child: child,
      );
}
