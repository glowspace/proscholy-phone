import 'package:flutter/material.dart';
import 'package:zpevnik/screens/content.dart';
import 'package:zpevnik/screens/initial.dart';
import 'package:zpevnik/screens/search.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const InitialScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const ContentScreen());
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchScreen(), fullscreenDialog: true);
      default:
        throw 'Unknown route: ${settings.name}';
    }
  }
}
