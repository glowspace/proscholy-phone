import 'package:flutter/material.dart';
import 'package:zpevnik/screens/content.dart';
import 'package:zpevnik/screens/initial.dart';
import 'package:zpevnik/screens/search.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CustomPageRoute(builder: (_) => const InitialScreen());
      case '/home':
        return CustomPageRoute(builder: (_) => const ContentScreen());
      case '/search':
        return CustomPageRoute(builder: (_) => const SearchScreen(), fullscreenDialog: true);
      default:
        throw 'Unknown route: ${settings.name}';
    }
  }
}

class CustomPageRoute extends MaterialPageRoute {
  // @override
  // Duration get transitionDuration => const Duration(milliseconds: 5000);

  CustomPageRoute({required WidgetBuilder builder, bool fullscreenDialog = false})
      : super(builder: builder, fullscreenDialog: fullscreenDialog);
}