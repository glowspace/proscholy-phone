import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/routes/route_generator.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/links.dart';

const _title = 'Zpěvník';

void main() {
  runApp(const MainWidget());

  // debugRepaintRainbowEnabled = true;
}

final _navigatorKey = GlobalKey<NavigatorState>();

class MainWidget extends StatelessWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationProvider = NavigationProvider();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        Provider.value(value: navigationProvider),
      ],
      builder: (_, __) => MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        title: _title,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        onGenerateRoute: RouteGenerator.generateRoute,
        navigatorObservers: [navigationProvider],
        builder: (_, child) => LinksHandlerWrapper(navigatorKey: _navigatorKey, child: child),
      ),
    );
  }
}
