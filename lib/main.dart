import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';
import 'package:zpevnik/utils/updater.dart';
import 'package:zpevnik/screens/content_screen.dart';
import 'package:zpevnik/screens/loading_screen.dart';

void main() => runApp(kDebugMode ? DebugWidget() : const MainWidget());

class MainWidget extends StatefulWidget {
  const MainWidget();

  @override
  State<StatefulWidget> createState() => _MainWidgetstate();
}

class _MainWidgetstate extends State<MainWidget> with PlatformStateMixin, WidgetsBindingObserver {
  final String _title = 'Zpěvník';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget iOSWidget(BuildContext context) => _wrap(
        context,
        (context, home) => CupertinoApp(title: _title, theme: AppThemeNew.of(context).cupertinoTheme, home: home),
      );

  @override
  Widget androidWidget(BuildContext context) => _wrap(
        context,
        (context, home) => MaterialApp(title: _title, theme: AppThemeNew.of(context).materialTheme, home: home),
      );

  // wraps platform specific app with `AppThemeNew`
  Widget _wrap(BuildContext context, Widget Function(BuildContext, Widget) builder) {
    final platform = Theme.of(context).platform;

    return AppThemeNew(
      child: Builder(
        builder: (context) => builder(
          context,
          FutureBuilder<bool>(
            future: Updater.shared.update(),
            builder: (context, snapshot) => snapshot.hasData ? ContentScreen() : LoadingScreen(),
          ),
        ),
      ),
      brightness: WidgetsBinding.instance.window.platformBrightness,
      platform: platform,
    );
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {});

    super.didChangePlatformBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}

// widget for setting platform for debugging
class DebugWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Theme(data: ThemeData(platform: TargetPlatform.iOS), child: MainWidget());
}
