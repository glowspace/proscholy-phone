import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
// import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zpevnik/firebase_options.dart';
import 'package:zpevnik/providers/app_dependencies.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/providers/presentation.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/screens/initial.dart';
import 'package:zpevnik/screens/presentation.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/extensions.dart';

const _title = 'Zpěvník';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final appDependencies = AppDependencies(
    sharedPreferences: await SharedPreferences.getInstance(),
  );

  void appRunner() => runApp(ProviderScope(
        overrides: [appDependenciesProvider.overrideWithValue(appDependencies)],
        child: const MainWidget(),
      ));

  if (kDebugMode) return appRunner();

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://59762f67d1644603bddb1f0fc27849dd@sentry.glowspace.cz/2';
      options.tracesSampleRate = 1.0;
    },
    appRunner: appRunner,
  );
}

class MainWidget extends ConsumerWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkModeEnabled = ref.watch(settingsProvider.select((settings) => settings.darkModeEnabled));

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
          ChangeNotifierProvider(create: (_) => PresentationProvider()),
        ],
        builder: (_, __) => child!,
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
    return const MaterialApp(debugShowCheckedModeBanner: false, title: _title, home: PresentationScreen());
  }
}
