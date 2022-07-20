import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/routes/route_generator.dart';
import 'package:zpevnik/utils/links.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.read<NavigationProvider>();
    final isFullScreen = context.select<NavigationProvider, bool>((provider) => provider.isFullScreen);

    return WillPopScope(
      onWillPop: () async => !(await navigationProvider.navigatorKey.currentState?.maybePop() ?? false),
      child: LinksHandlerWrapper(
        child: LayoutBuilder(
          builder: (_, constraints) {
            if (constraints.maxWidth > kTabletSizeBreakpoint && constraints.maxHeight > kTabletSizeBreakpoint) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedAlign(
                    alignment: Alignment.center,
                    duration: kDefaultAnimationDuration,
                    widthFactor: isFullScreen ? 0 : 1,
                    child: ClipRect(
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        width: 320,
                        child: Navigator(
                          key: navigationProvider.menuNavigatorKey,
                          observers: [navigationProvider.menuNavigatorObserver!, HeroController()],
                          onGenerateRoute: MenuRouteGenerator.generateRoute,
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 0),
                  Expanded(
                    child: ClipRect(
                      clipBehavior: Clip.antiAlias,
                      child: Navigator(
                        key: navigationProvider.navigatorKey,
                        observers: [navigationProvider.navigatorObserver, HeroController()],
                        onGenerateRoute: RouteGenerator.generateRoute,
                      ),
                    ),
                  ),
                ],
              );
            }

            return Navigator(
              key: navigationProvider.navigatorKey,
              observers: [navigationProvider.navigatorObserver, HeroController()],
              onGenerateRoute: RouteGenerator.generateRoute,
            );
          },
        ),
      ),
    );
  }
}
