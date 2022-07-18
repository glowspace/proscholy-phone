import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/routes/route_generator.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.read<NavigationProvider>();

    return WillPopScope(
      onWillPop: () async => !(await navigationProvider.navigatorKey.currentState?.maybePop() ?? false),
      child: LayoutBuilder(
        builder: (_, constraints) {
          if (constraints.maxWidth > kTabletWidthBreakpoint) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 320,
                  child: Navigator(
                    key: navigationProvider.menuNavigatorKey,
                    onGenerateRoute: MenuRouteGenerator.generateRoute,
                  ),
                ),
                const VerticalDivider(width: 0),
                Expanded(
                  child: Navigator(
                    key: navigationProvider.navigatorKey,
                    onGenerateRoute: RouteGenerator.generateRoute,
                  ),
                ),
              ],
            );
          }

          return Navigator(
            key: navigationProvider.navigatorKey,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
