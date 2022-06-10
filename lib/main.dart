import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/route_generator.dart';

const _title = 'Zpěvník';

void main() {
  runApp(const MainWidget());
}

class MainWidget extends StatelessWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: CupertinoColors.lightBackgroundGray,
      backgroundColor: Colors.white,
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: Colors.purple.shade700.withAlpha(0x30),
        iconTheme: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected) ? IconThemeData(color: Colors.purple.shade900) : null,
        ),
      ),
      useMaterial3: true,
    );

    final darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: CupertinoColors.darkBackgroundGray,
      backgroundColor: Colors.black,
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: Colors.purple.shade700.withAlpha(0x30),
        iconTheme: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected) ? IconThemeData(color: Colors.purple.shade900) : null,
        ),
      ),
      useMaterial3: true,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: lightTheme,
      darkTheme: darkTheme,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
