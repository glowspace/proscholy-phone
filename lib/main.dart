import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/screens/initial.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/extensions.dart';

const _title = 'Zpěvník';

Future<void> main() async {
  if (kDebugMode) return runApp(const MainWidget());

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://59762f67d1644603bddb1f0fc27849dd@sentry.glowspace.cz/2';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MainWidget()),
  );
}

class MainWidget extends StatelessWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: _title,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const InitialScreen(),
        builder: (context, child) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DataProvider()),
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
            ChangeNotifierProvider(create: (_) => NavigationProvider(hasMenu: MediaQuery.of(context).isTablet)),
          ],
          builder: (_, __) => child!,
        ),
      ),
    );
  }
}
