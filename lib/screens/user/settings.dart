import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/custom/future_builder.dart';
import 'package:zpevnik/platform/components/navigation_bar.dart';
import 'package:zpevnik/platform/components/scaffold.dart';
import 'package:zpevnik/platform/components/switch.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/components/font_size_slider.dart';
import 'package:zpevnik/components/selector_widget.dart';
import 'package:zpevnik/screens/user/components/menu_section.dart';
import 'package:zpevnik/theme.dart';

const double kSelectorWidgetWidth = 96;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      navigationBar: const PlatformNavigationBar(title: 'Nastavení'),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDisplaySettings(context),
              const SizedBox(height: kDefaultPadding),
              _buildSongSettings(context),
              const SizedBox(height: kDefaultPadding),
              _buildLastUpdateInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisplaySettings(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Consumer<SettingsProvider>(
      builder: (_, provider, __) => MenuSection(
        title: 'Nastavení zobrazení',
        children: [
          Row(children: [
            const Expanded(child: Text('Blokovat zhasínání displeje')),
            PlatformSwitch(
              value: provider.blockDisplayOff,
              onChanged: provider.changeBlockDisplayOff,
            ),
          ]),
          Row(children: [
            const Expanded(child: Text('Tmavý mód')),
            PlatformSwitch(
              value: provider.isDarkMode ?? (appTheme.brightness == Brightness.dark),
              onChanged: provider.changeIsDarkMode,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSongSettings(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final accidentalsStyle = appTheme.bodyTextStyle?.copyWith(fontSize: 20, fontFamily: 'KaiseiHarunoUmi');

    return Consumer<SettingsProvider>(
      builder: (_, provider, __) => MenuSection(
        title: 'Nastavení písní',
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
              width: kSelectorWidgetWidth,
            ),
          ]),
          Row(children: [
            const Expanded(child: Text('Akordy')),
            SelectorWidget(
              onSelected: (index) => provider.showChords = index == 1,
              options: [
                Icon(Icons.visibility_off, color: appTheme.iconColor),
                Icon(Icons.visibility, color: appTheme.iconColor),
              ],
              selected: provider.showChords ? 1 : 0,
              width: kSelectorWidgetWidth,
            ),
          ]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Text('Velikost písma'),
              FontSizeSlider(),
            ],
          ),
          Row(children: [
            const Expanded(child: Text('Zobrazit spodní nabídku')),
            PlatformSwitch(
              value: provider.showBottomOptions,
              onChanged: provider.changeShowBottomOptions,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildLastUpdateInfo(BuildContext context) {
    final settingsProvider = context.read<SettingsProvider>();

    Future<void> _updateFuture = Future.value();

    return StatefulBuilder(
      builder: (context, setState) => CustomFutureBuilder<void>(
        future: _updateFuture,
        wrapperBuilder: (_, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            child,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              child: Text(
                'Datum poslední aktualizace: ${settingsProvider.lastUpdate}',
                style: AppTheme.of(context).captionTextStyle,
              ),
            ),
          ],
        ),
        builder: (_, __) => TextButton(
          onPressed: () => setState(() {
            _updateFuture = _forceUpdate(context);
          }),
          child: const Text('Aktualizovat databázi'),
        ),
      ),
    );
  }

  Future<void> _forceUpdate(BuildContext context) async {
    final updated = await context.read<DataProvider>().update(forceUpdate: true);

    if (updated) {
      Fluttertoast.showToast(
        msg: 'Aktualizace písní proběhla úspěšně.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
  }
}
