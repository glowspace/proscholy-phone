import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zpevnik/screens/utils/updateable.dart';
import 'package:zpevnik/theme.dart';

class StatusBarWrapper extends StatefulWidget {
  final Widget child;

  const StatusBarWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _StatusBarWrapperState createState() => _StatusBarWrapperState();

  static StatusBarData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_InheritedStatusBarWrapper>()!.statusBarData;
}

class _StatusBarWrapperState extends State<StatusBarWrapper> with Updateable {
  final StatusBarData statusBarData = StatusBarData();

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return _InheritedStatusBarWrapper(
      statusBarData: statusBarData,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: statusBarData.navigationBarColor.value ?? appTheme.backgroundColor,
          systemNavigationBarColor: appTheme.backgroundColor,
          statusBarBrightness: appTheme.brightness,
          statusBarIconBrightness: appTheme.brightness == Brightness.light ? Brightness.dark : Brightness.light,
        ),
        child: widget.child,
      ),
    );
  }

  @override
  List<Listenable> get listenables => [statusBarData.navigationBarColor];
}

class _InheritedStatusBarWrapper extends InheritedWidget {
  final StatusBarData statusBarData;

  _InheritedStatusBarWrapper({required Widget child, required this.statusBarData}) : super(child: child);

  @override
  bool updateShouldNotify(_InheritedStatusBarWrapper oldWidget) => true;
}

class StatusBarData {
  ValueNotifier<Color?> navigationBarColor = ValueNotifier(null);
}
