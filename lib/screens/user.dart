import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/custom/close_button.dart';
import 'package:zpevnik/components/font_size_slider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/icon_item.dart';
import 'package:zpevnik/components/logo.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/components/selector_widget.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/utils/extensions.dart';
import 'package:zpevnik/utils/url_launcher.dart';

const double _avatarRadius = 48;
const double _settingsOptionsWidth = 100;

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const Logo(),
                  // Center(
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                  //     child: const CircleAvatar(
                  //       backgroundImage: AssetImage('assets/images/songbooks/default.png'),
                  //       backgroundColor: Colors.transparent,
                  //       radius: _avatarRadius,
                  //     ),
                  //   ),
                  // ),
                  // Center(child: Text('Patrik Dobiáš', style: textTheme.titleLarge)),
                  // const SizedBox(height: kDefaultPadding),
                  // Highlightable(
                  //   onTap: () {},
                  //   child: Text('Odhlásit se', style: textTheme.bodyMedium?.copyWith(color: red)),
                  // ),
                  // const SizedBox(height: kDefaultPadding),
                  _buildAppSettings(context),
                  _buildSongSettings(context),
                  _buildLinksSection(context),
                  Highlightable(
                    onTap: () => NavigationProvider.of(context).pushNamed('/about'),
                    child: Text('O projektu', style: textTheme.bodySmall),
                  ),
                  const SizedBox(height: kDefaultPadding),
                ],
              ),
            ),
            const CustomCloseButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppSettings(BuildContext context) {
    final systemDarkModeEnabled = MediaQuery.of(context).platformBrightness.isDark;

    return Consumer<SettingsProvider>(
      builder: (_, provider, __) => Section(
        title: Text('Nastavení', style: Theme.of(context).textTheme.titleMedium),
        margin: const EdgeInsets.all(kDefaultPadding),
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: SwitchListTile.adaptive(
          title: Text('Tmavý mód', style: Theme.of(context).textTheme.bodyMedium),
          value: provider.darkModeEnabled ?? systemDarkModeEnabled,
          onChanged: (value) => provider.darkModeEnabled = value == systemDarkModeEnabled ? null : value,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildSongSettings(BuildContext context) {
    final accidentalsStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(fontFamily: 'KaiseiHarunoUmi');

    return Consumer<SettingsProvider>(
      builder: (_, provider, __) => Section(
        title: Text('Nastavení písní', style: Theme.of(context).textTheme.titleMedium),
        margin: const EdgeInsets.all(kDefaultPadding),
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding),
        child: Column(
          children: [
            Row(children: [
              const Expanded(child: Text('Posuvky')),
              SelectorWidget(
                onSelected: (index) => provider.accidentals = index,
                options: [
                  Text('#', style: accidentalsStyle, textAlign: TextAlign.center),
                  Text('♭', style: accidentalsStyle, textAlign: TextAlign.center)
                ],
                selected: provider.accidentals,
                width: _settingsOptionsWidth,
              ),
            ]),
            const Divider(height: kDefaultPadding),
            Row(children: [
              const Expanded(child: Text('Akordy')),
              SelectorWidget(
                onSelected: (index) => provider.showChords = index == 1,
                options: const [Icon(Icons.visibility_off, size: 20), Icon(Icons.visibility, size: 20)],
                selected: provider.showChords ? 1 : 0,
                width: _settingsOptionsWidth,
              ),
            ]),
            const Divider(height: kDefaultPadding),
            const SizedBox(height: kDefaultPadding / 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [Text('Velikost písma'), FontSizeSlider()],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinksSection(BuildContext context) {
    final theme = Theme.of(context);

    return Section(
      title: Text('Odkazy', style: theme.textTheme.titleMedium),
      margin: const EdgeInsets.all(kDefaultPadding),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding),
      child: Column(
        children: [
          Highlightable(
            onTap: () => launch(proscholyUrl),
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            child: const IconItem(text: 'Webová verze', icon: Icons.language),
          ),
          Highlightable(
            onTap: () => launch(theme.platform.isIos ? feedbackIOSUrl : feedbackAndroidUrl),
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            child: const IconItem(text: 'Zpětná vazba', icon: Icons.feedback),
          ),
          Highlightable(
            onTap: () => launch(addSongUrl),
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            child: const IconItem(text: 'Přidat píseň', icon: Icons.add),
          ),
        ],
      ),
    );
  }

  // Widget _buildLastUpdateInfo(BuildContext context) {
  //   final settingsProvider = context.read<SettingsProvider>();

  //   Future<void> _updateFuture = Future.value();

  //   return StatefulBuilder(
  //     builder: (context, setState) => CustomFutureBuilder<void>(
  //       future: _updateFuture,
  //       wrapperBuilder: (_, child) => Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           child,
  //           Container(
  //             padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
  //             child: Text(
  //               'Datum poslední aktualizace: ${settingsProvider.lastUpdate}',
  //               style: AppTheme.of(context).bodySmallTextStyle,
  //             ),
  //           ),
  //         ],
  //       ),
  //       builder: (_, __) => TextButton(
  //         onPressed: () => setState(() {
  //           _updateFuture = _forceUpdate(context);
  //         }),
  //         child: const Text('Aktualizovat databázi'),
  //       ),
  //     ),
  //   );
  // }
}
