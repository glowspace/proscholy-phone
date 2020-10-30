import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/utils/platform.dart';
import 'package:zpevnik/utils/updater.dart';
import 'package:zpevnik/screens/content_screen.dart';
import 'package:zpevnik/screens/loading_screen.dart';

void main() => runApp(MainWidget());

class MainWidget extends StatelessWidget with PlatformWidgetMixin {
  final String _title = 'Zpěvník';

  @override
  Widget iOSWidget(BuildContext context) => CupertinoApp(
        title: _title,
        home: _home(context),
      );

  @override
  Widget androidWidget(BuildContext context) => MaterialApp(
        title: _title,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: _home(context),
      );

  Widget _home(BuildContext context) => FutureBuilder<bool>(
        future: Updater.shared.update(),
        builder: (context, snapshot) => snapshot.hasData ? ContentScreen() : LoadingScreen(),
      );
}
