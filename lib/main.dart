import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/screens/initial.dart';
import 'package:zpevnik/theme.dart';

const _title = 'Zpěvník';

void main() {
  runApp(const MainWidget());

  // debugRepaintRainbowEnabled = true;
}

class MainWidget extends StatelessWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        Provider(create: (_) => NavigationProvider()),
      ],
      builder: (_, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: _title,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const InitialScreen(),
      ),
    );
  }
}
