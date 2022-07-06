import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/route_generator.dart';

const _title = 'Zpěvník';

void main() {
  runApp(const MainWidget());

  // debugRepaintRainbowEnabled = true;
}

class MainWidget extends StatelessWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: CupertinoColors.lightBackgroundGray,
      colorScheme: ColorScheme.fromSeed(seedColor: blue),
      appBarTheme: ThemeData.light().appBarTheme.copyWith(
            backgroundColor: CupertinoColors.lightBackgroundGray,
            shadowColor: Colors.grey,
            elevation: 1,
          ),
      splashFactory: NoSplash.splashFactory,
      useMaterial3: true,
    );

    final darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: ThemeData.dark().appBarTheme.copyWith(
            backgroundColor: Colors.black,
            shadowColor: Colors.grey,
            elevation: 1,
          ),
      colorScheme: ColorScheme.fromSeed(seedColor: blue, brightness: Brightness.dark),
      splashFactory: NoSplash.splashFactory,
      useMaterial3: true,
    );

    final navigationProvider = NavigationProvider();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        Provider.value(value: navigationProvider),
      ],
      builder: (_, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: _title,
        theme: lightTheme,
        darkTheme: darkTheme,
        onGenerateRoute: RouteGenerator.generateRoute,
        navigatorObservers: [navigationProvider],
      ),
    );
  }
}
