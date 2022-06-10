import 'package:flutter/material.dart';
import 'package:zpevnik/screens/content.dart';
import 'package:zpevnik/screens/initial.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const InitialScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const ContentScreen());
      default:
        throw 'Unknown route: ${settings.name}';
    }
  }
}
