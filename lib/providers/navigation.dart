import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/utils/navigation_observer.dart';

class NavigationProvider {
  final bool hasMenu;

  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<NavigatorState>? menuNavigatorKey;

  final CustomNavigatorObserver navigatorObserver;
  final CustomNavigatorObserver? menuNavigatorObserver;

  NavigationProvider({this.hasMenu = false})
      : navigatorKey = GlobalKey(),
        menuNavigatorKey = hasMenu ? GlobalKey() : null,
        navigatorObserver = CustomNavigatorObserver(),
        menuNavigatorObserver = hasMenu ? CustomNavigatorObserver() : null;

  static NavigationProvider of(BuildContext context) {
    return context.read<NavigationProvider>();
  }

  static NavigatorState navigatorOf(BuildContext context) {
    final navigationProvider = context.read<NavigationProvider>();

    return navigationProvider.navigatorKey.currentState ?? Navigator.of(context);
  }

  Future<T?>? pushNamed<T>(String name, {Object? arguments}) {
    if (name == '/playlist') {
      return _maybeMenuNavigator.currentState?.pushNamed(name, arguments: arguments);
    }

    return navigatorKey.currentState?.pushNamed<T>(name, arguments: arguments);
  }

  void popToOrPushNamed(String name, {Object? arguments}) {
    if (navigatorObserver.navigationStack.contains(name)) {
      navigatorKey.currentState?.popUntil(ModalRoute.withName(name));
    } else if (menuNavigatorObserver?.navigationStack.contains(name) ?? false) {
      menuNavigatorKey?.currentState?.popUntil(ModalRoute.withName(name));
    } else {
      pushNamed(name, arguments: arguments);
    }
  }

  GlobalKey<NavigatorState> get _maybeMenuNavigator => menuNavigatorKey ?? navigatorKey;
}
