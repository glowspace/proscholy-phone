import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zpevnik/components/custom/close_button.dart';
import 'package:zpevnik/components/font_size_slider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/logo.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/components/selector_widget.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/utils/extensions.dart';

// const double _avatarRadius = 48;
const double _settingsOptionsWidth = 100;

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // final width = MediaQuery.of(context).size.width;

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
                  HighlightableTextButton(
                    onTap: () => context.push('/about'),
                    textStyle: textTheme.bodySmall,
                    child: const Text('O projektu'),
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
    final textTheme = Theme.of(context).textTheme;
    final systemDarkModeEnabled = MediaQuery.of(context).platformBrightness.isDark;

    return Section(
      title: Text('Nastavení', style: textTheme.titleMedium),
      margin: const EdgeInsets.all(kDefaultPadding),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Consumer(
        builder: (_, ref, __) => SwitchListTile.adaptive(
          title: Text('Tmavý mód', style: textTheme.bodyMedium),
          value: ref.watch(settingsProvider.select((settings) => settings.darkModeEnabled)) ?? systemDarkModeEnabled,
          onChanged: (value) =>
              ref.read(settingsProvider.notifier).changeDarkModeEnabled(value == systemDarkModeEnabled ? null : value),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildSongSettings(BuildContext context) {
    final accidentalsStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(fontFamily: 'KaiseiHarunoUmi');

    return Section(
      title: Text('Nastavení písní', style: Theme.of(context).textTheme.titleMedium),
      margin: const EdgeInsets.all(kDefaultPadding),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding),
      child: Column(
        children: [
          Row(children: [
            const Expanded(child: Text('Posuvky')),
            Consumer(
              builder: (_, ref, __) => SelectorWidget(
                onSelected: ref.read(settingsProvider.notifier).changeAccidentals,
                options: [
                  Text('#', style: accidentalsStyle, textAlign: TextAlign.center),
                  Text('♭', style: accidentalsStyle, textAlign: TextAlign.center)
                ],
                selected: ref.watch(settingsProvider.select((settings) => settings.accidentals)),
                width: _settingsOptionsWidth,
              ),
            ),
          ]),
          const Divider(height: kDefaultPadding),
          Row(children: [
            const Expanded(child: Text('Akordy')),
            Consumer(
              builder: (context, ref, __) => SelectorWidget(
                onSelected: (index) => ref.read(settingsProvider.notifier).changeShowChords(index == 1),
                options: const [Icon(Icons.visibility_off, size: 20), Icon(Icons.visibility, size: 20)],
                selected: ref.watch(settingsProvider.select((settings) => settings.showChords)) ? 1 : 0,
                width: _settingsOptionsWidth,
              ),
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
