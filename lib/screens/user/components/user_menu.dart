import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/providers/settings_provider.dart';
import 'package:zpevnik/screens/components/bottom_form_sheet.dart';
import 'package:zpevnik/screens/components/menu_item.dart';
import 'package:zpevnik/screens/user/about_screen.dart';
import 'package:zpevnik/screens/user/settings_screen.dart';

class UserMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BottomFormSheet(
        title: 'Ostatní',
        items: [
          MenuItem(
            title: 'Nastavení',
            icon: Icons.settings,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ChangeNotifierProvider.value(value: SettingsProvider.shared, child: SettingsScreen()),
            )),
          ),
          MenuItem(
            title: 'Webová verze',
            icon: Icons.language,
            onPressed: () => launch(proscholyUrl),
          ),
          MenuItem(
            title: 'Zpětná vazba',
            icon: Icons.feedback,
            onPressed: () =>
                launch(Theme.of(context).platform == TargetPlatform.iOS ? feedbackIOSUrl : feedbackAndroidUrl),
          ),
          MenuItem(
            title: 'Přidat píseň',
            icon: Icons.add,
            onPressed: () => launch(addSongUrl),
          ),
          MenuItem(
            title: 'O projektu',
            icon: Icons.info,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutScreen())),
          ),
        ],
      );
}
