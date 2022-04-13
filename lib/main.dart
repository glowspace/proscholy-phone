import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zpevnik/platform/mixin.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/screens/miniplayer_wrapper.dart';
import 'package:zpevnik/theme.dart';

const _title = 'Zpěvník';

late SharedPreferences _prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _prefs = await SharedPreferences.getInstance();

  runApp(const MainWidget());
}

class MainWidget extends StatelessWidget with PlatformMixin {
  const MainWidget({Key? key}) : super(key: key);

  @override
  Widget buildAndroid(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: AppTheme.of(context).materialTheme,
      home: MiniPlayerWrapper(),
    );
  }

  @override
  Widget buildIos(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: AppTheme.of(context).cupertinoTheme,
      home: MiniPlayerWrapper(),
      // needed by youtube player
      localizationsDelegates: const [DefaultMaterialLocalizations.delegate],
    );
  }

  @override
  Widget buildWrapper(BuildContext context, Widget Function(BuildContext) builder) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(_prefs),
      builder: (_, __) => AppTheme(child: Builder(builder: builder)),
    );
  }
}
