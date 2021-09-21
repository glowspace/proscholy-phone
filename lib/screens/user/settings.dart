import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/platform/components/progress_indicator.dart';
import 'package:zpevnik/platform/components/scaffold.dart';
import 'package:zpevnik/platform/components/switch.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/screens/components/font_size_slider.dart';
import 'package:zpevnik/screens/components/highlightable.dart';
import 'package:zpevnik/screens/components/selector_widget.dart';
import 'package:zpevnik/screens/user/components/menu_row.dart';
import 'package:zpevnik/screens/user/components/menu_section.dart';
import 'package:zpevnik/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<void> _updateFuture = Future.value();

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final accidentalsStyle = appTheme.bodyTextStyle?.copyWith(fontSize: 20, fontFamily: 'KaiseiHarunoUmi');
    final settingsProvider = context.watch<SettingsProvider>();

    return PlatformScaffold(
      title: 'Nastavení',
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MenuSection(
                title: 'Nastavení zobrazení',
                children: [
                  MenuRow(
                    title: 'Blokovat zhasínání displeje',
                    child: PlatformSwitch(
                      value: settingsProvider.blockDisplayOff,
                      onChanged: settingsProvider.changeBlockDisplayOff,
                    ),
                  ),
                  MenuRow(
                    title: 'Tmavý mód',
                    child: PlatformSwitch(
                      value: settingsProvider.isDarkMode ?? (appTheme.brightness == Brightness.dark),
                      onChanged: settingsProvider.changeIsDarkMode,
                    ),
                  ),
                ],
              ),
              MenuSection(
                title: 'Nastavení písní',
                children: [
                  MenuRow(
                    title: 'Posuvky',
                    child: SelectorWidget(
                      onSelected: (index) => settingsProvider.accidentals = index,
                      options: [
                        Text('#', style: accidentalsStyle, textAlign: TextAlign.center),
                        Text('♭', style: accidentalsStyle, textAlign: TextAlign.center)
                      ],
                      selected: settingsProvider.accidentals,
                      width: 96,
                    ),
                  ),
                  MenuRow(
                    title: 'Akordy',
                    child: SelectorWidget(
                      onSelected: (index) => settingsProvider.showChords = index == 1,
                      options: [
                        Icon(Icons.visibility_off, color: appTheme.iconColor),
                        Icon(Icons.visibility, color: appTheme.iconColor),
                      ],
                      selected: settingsProvider.showChords ? 1 : 0,
                      width: 96,
                    ),
                  ),
                  MenuRow(child: FontSizeSlider()),
                  MenuRow(
                    title: 'Zobrazit spodní nabídku',
                    child: PlatformSwitch(
                      value: settingsProvider.showBottomOptions,
                      onChanged: settingsProvider.changeShowBottomOptions,
                    ),
                  ),
                ],
              ),
              _buildLastUpdateInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLastUpdateInfo() {
    final settingsProvider = context.watch<SettingsProvider>();

    return FutureBuilder(
        future: _updateFuture,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (snapshot.connectionState == ConnectionState.done)
                Highlightable(
                  padding: EdgeInsets.all(kDefaultPadding),
                  onPressed: _forceUpdate,
                  child: Text('Aktualizovat databázi'),
                )
              else
                Container(padding: EdgeInsets.all(kDefaultPadding), child: PlatformProgressIndicator()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Text(
                  'Datum poslední aktualizace: ${settingsProvider.lastUpdate}',
                  style: AppTheme.of(context).captionTextStyle,
                ),
              ),
            ],
          );
        });
  }

  void _forceUpdate() async {
    setState(() {
      _updateFuture = () async {
        if (await context.read<DataProvider>().update(forceUpdate: true))
          Fluttertoast.showToast(
            msg: 'Aktualizace písní proběhla úspěšně.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
      }();
    });
  }
}
