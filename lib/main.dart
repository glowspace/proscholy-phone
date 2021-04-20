import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/custom/custom_scroll_behavior.dart';
import 'package:zpevnik/global.dart';
import 'package:zpevnik/providers/full_screen_provider.dart';
import 'package:zpevnik/providers/settings_provider.dart';
import 'package:zpevnik/providers/sync_provider.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/platform/mixin.dart';
import 'package:zpevnik/utils/preloader.dart';
import 'package:zpevnik/utils/updater.dart';
import 'package:zpevnik/screens/content_screen.dart';
import 'package:zpevnik/screens/loading_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: check this, it doesn't seem to be working
  await Preloader.preloadImages();
  await Global.shared.init();

  runApp(MainWidget());
}

class MainWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainWidgetstate();
}

class _MainWidgetstate extends State<MainWidget> with PlatformStateMixin {
  final String _title = 'Zpěvník';

  @override
  Widget iOSWidget(BuildContext context) => _wrap(
        context,
        (context, home) => CupertinoApp(
          debugShowCheckedModeBanner: false,
          // needed by youtube player
          localizationsDelegates: [DefaultMaterialLocalizations.delegate],
          navigatorObservers: _navigatorObservers,
          title: _title,
          theme: AppTheme.of(context).cupertinoTheme,
          home: home,
        ),
      );

  @override
  Widget androidWidget(BuildContext context) => _wrap(
        context,
        (context, home) => MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: _navigatorObservers,
          builder: (context, child) => ScrollConfiguration(behavior: CustomScrollBehavior(), child: child),
          title: _title,
          theme: AppTheme.of(context).materialTheme,
          home: home,
        ),
      );

  // wraps platform specific app with `AppTheme`
  Widget _wrap(BuildContext context, Widget Function(BuildContext, Widget) builder) {
    final platform = kDebugMode ? TargetPlatform.iOS : Theme.of(context).platform;

    return ChangeNotifierProvider(
      create: (context) => SyncProvider(),
      builder: (context, _) => ChangeNotifierProvider(
        create: (context) => SettingsProvider(),
        builder: (context, _) => AppTheme(
          child: ChangeNotifierProvider(
            create: (context) => FullScreenProvider(),
            builder: builder,
            child: FutureBuilder<bool>(
              future: Updater.shared.update(),
              builder: (context, snapshot) => snapshot.hasData ? ContentScreen() : LoadingScreen(),
            ),
          ),
          platform: platform,
        ),
      ),
    );
  }

  List<NavigatorObserver> get _navigatorObservers => [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())];
}
