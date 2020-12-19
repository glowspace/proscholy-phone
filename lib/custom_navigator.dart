import 'package:flutter/material.dart';

// wrapper for android, so bottom navigation bar is persistent across screens
class CustomNavigator extends StatelessWidget {
  final Widget child;

  const CustomNavigator({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => Navigator(
        initialRoute: '/',
        onGenerateRoute: (routeSettings) => MaterialPageRoute(builder: (context) => child),
      );
}
