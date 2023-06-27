import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
// import 'package:flutter/rendering.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zpevnik/firebase_options.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/providers/app_dependencies.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/routing/router.dart';
import 'package:zpevnik/screens/presentation.dart';
import 'package:zpevnik/theme.dart';

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

  void appRunner() => runApp(ProviderScope(
        observers: [MyProviderObserver()],
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
  const MainWidget({super.key});

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

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: ref.read(appNavigatorProvider).appRouter,
    );
  }
}

@pragma('vm:entry-point')
void mainPresentation() => runApp(const MainPresentation());

class MainPresentation extends StatelessWidget {
  const MainPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, title: _title, home: PresentationScreen());
  }
}

class MyProviderObserver extends ProviderObserver {
  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value, ProviderContainer container) {
    super.didAddProvider(provider, value, container);

    log('added provider: $provider');
  }

  @override
  void didUpdateProvider(
      ProviderBase<Object?> provider, Object? previousValue, Object? newValue, ProviderContainer container) {
    super.didUpdateProvider(provider, previousValue, newValue, container);

    log('updated provider: $provider');
  }

  @override
  void didDisposeProvider(ProviderBase<Object?> provider, ProviderContainer container) {
    super.didDisposeProvider(provider, container);

    log('disposed provider: $provider');
  }

  @override
  void providerDidFail(
      ProviderBase<Object?> provider, Object error, StackTrace stackTrace, ProviderContainer container) {
    super.providerDidFail(provider, error, stackTrace, container);

    log('provider failed: $provider, $error, $stackTrace');
  }
}
