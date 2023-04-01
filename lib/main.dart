import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';
// import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:zpevnik/firebase_options.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/screens/initial.dart';
import 'package:zpevnik/screens/presentation.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/extensions.dart';

const _title = 'Zpěvník';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      builder: (_, __) => Builder(
        builder: (context) {
          final darkModeEnabled = context.select<SettingsProvider, bool?>((provider) => provider.darkModeEnabled);
          ThemeMode? themeMode;

          if (darkModeEnabled != null) {
            if (darkModeEnabled) {
              themeMode = ThemeMode.dark;
            } else {
              themeMode = ThemeMode.light;
            }
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: _title,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeMode,
            home: const InitialScreen(),
            builder: (context, child) => MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => DataProvider()),
                ChangeNotifierProvider(create: (_) => NavigationProvider(hasMenu: MediaQuery.of(context).isTablet)),
              ],
              builder: (_, __) => child!,
            ),
          );
        },
      ),
    );
  }
}

@pragma('vm:entry-point')
void mainPresentation() => runApp(const MainPresentation());

class MainPresentation extends StatelessWidget {
  const MainPresentation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: AppTheme.dark(),
      home: StreamBuilder<String>(
        stream: Presentation().getDataStream(),
        builder: (_, snapshot) {
          if (snapshot.hasData) return PresentationScreen(key: Key(snapshot.data!), presentedLyrics: snapshot.data!);

          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
