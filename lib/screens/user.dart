import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/custom/close_button.dart';
import 'package:zpevnik/components/font_size_slider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/components/selector_widget.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/settings.dart';

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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  const CustomCloseButton(),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/logos/apple_dark.png'),
                        radius: _avatarRadius,
                      ),
                    ),
                  ),
                ],
              ),
              Center(child: Text('Patrik Dobiáš', style: textTheme.titleLarge)),
              const SizedBox(height: kDefaultPadding),
              Highlightable(
                onTap: () {},
                child: Text('Odhlásit se', style: textTheme.bodyMedium?.copyWith(color: red)),
              ),
              const SizedBox(height: kDefaultPadding),
              _buildDisplaySettings(context),
              _buildSongSettings(context),
              const SizedBox(height: kDefaultPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisplaySettings(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (_, provider, __) => Section(
        title: Text('Nastavení zobrazení', style: Theme.of(context).textTheme.titleMedium),
        margin: const EdgeInsets.all(kDefaultPadding),
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          children: [
            Row(children: [
              const Expanded(child: Text('Blokovat zhasínání displeje')),
              Switch.adaptive(
                value: provider.blockDisplayOff,
                onChanged: provider.changeBlockDisplayOff,
              ),
            ]),
            const Divider(height: kDefaultPadding),
            Row(children: [
              const Expanded(child: Text('Tmavý mód')),
              Switch.adaptive(
                value: provider.isDarkMode ?? false,
                onChanged: provider.changeIsDarkMode,
              ),
            ]),
          ],
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
                options: const [Icon(Icons.visibility_off), Icon(Icons.visibility)],
                selected: provider.showChords ? 1 : 0,
                width: _settingsOptionsWidth,
              ),
            ]),
            const Divider(height: kDefaultPadding),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Text('Velikost písma'),
                FontSizeSlider(),
              ],
            ),
          ],
        ),
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
  //               style: AppTheme.of(context).captionTextStyle,
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
