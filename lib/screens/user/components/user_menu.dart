import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/providers/settings_provider.dart';
import 'package:zpevnik/screens/components/bottom_form_sheet.dart';
import 'package:zpevnik/screens/user/about_screen.dart';
import 'package:zpevnik/screens/components/higlightable_row.dart';
import 'package:zpevnik/screens/user/settings_screen.dart';

class UserMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BottomFormSheet(
        title: 'Ostatní',
        items: [
          HighlightableRow(
            title: 'Nastavení',
            icon: Icons.settings,
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ChangeNotifierProvider.value(value: SettingsProvider.shared, child: SettingsScreen()),
            )),
          ),
          HighlightableRow(
            title: 'Webová verze',
            icon: Icons.language,
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            onPressed: () => launch(proscholyUrl),
          ),
          HighlightableRow(
            title: 'Zpětná vazba',
            icon: Icons.feedback,
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            onPressed: () => launch(Platform.isIOS ? feedbackIOSUrl : feedbackAndroidUrl),
          ),
          HighlightableRow(
            title: 'Přidat píseň',
            icon: Icons.add,
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            onPressed: () => launch(addSongUrl),
          ),
          HighlightableRow(
            title: 'O projektu',
            icon: Icons.info,
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutScreen())),
          ),
        ],
      );
}
