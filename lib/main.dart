import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zpevnik/firebase_options.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/providers/app_dependencies.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/providers/update.dart';
import 'package:zpevnik/routing/navigator_observer.dart';
import 'package:zpevnik/routing/router.dart';
import 'package:zpevnik/screens/presentation.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/services/external_actions.dart';
import 'package:zpevnik/utils/services/spotlight.dart';

const _title = 'Zpěvník';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final appDependencies = AppDependencies(
    sharedPreferences: await SharedPreferences.getInstance(),
    store: await openStore(),
    ftsDatabase: await openDatabase(join(await getDatabasesPath(), 'zpevnik.db')),
    packageInfo: await PackageInfo.fromPlatform(),
  );

  // initialize listeners for externals actions
  ExternalActionsService.instance.initialize();

  // load offline data during first start
  await loadInitial(appDependencies);

  // check if app was opened from spotlight search on iOS
  final initialRoute = await SpotlightService.instance.getInitialRoute();

  appRunner() => runApp(ProviderScope(
        overrides: [appDependenciesProvider.overrideWithValue(appDependencies)],
        child: MainWidget(initialRoute: initialRoute),
      ));

  if (kDebugMode) return appRunner();

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://4398b4421c372b093c4f88c16dff9c63@o4506177850572800.ingest.sentry.io/4506177851621376';
      options.tracesSampleRate = 1.0;
    },
    appRunner: appRunner,
  );
}

class MainWidget extends ConsumerWidget {
  final String? initialRoute;

  const MainWidget({super.key, this.initialRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkModeEnabled = ref.watch(settingsProvider.select((settings) => settings.darkModeEnabled));
    final seedColor = ref.watch(settingsProvider.select((settings) => Color(settings.seedColor)));

    ThemeMode? themeMode;

    if (darkModeEnabled != null) {
      if (darkModeEnabled) {
        themeMode = ThemeMode.dark;
      } else {
        themeMode = ThemeMode.light;
      }
    }

    return MaterialApp(
      navigatorKey: ExternalActionsService.instance.navigatorKey,
      supportedLocales: const [Locale('cs', 'CZ')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: AppTheme.light(seedColor),
      darkTheme: AppTheme.dark(seedColor),
      themeMode: themeMode,
      initialRoute: initialRoute ?? '/',
      onGenerateRoute: AppRouter.generateRoute,
      navigatorObservers: [ref.read(appNavigatorObserverProvider)],
    );
  }
}

@pragma('vm:entry-point')
void mainPresentation() => runApp(const MaterialApp(home: PresentationScreen(), debugShowCheckedModeBanner: false));
