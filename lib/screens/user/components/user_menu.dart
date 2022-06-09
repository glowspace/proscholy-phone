import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/platform/utils/route_builder.dart';
import 'package:zpevnik/components/bottom_form_sheet.dart';
import 'package:zpevnik/components/icon_item.dart';
import 'package:zpevnik/screens/user/about.dart';
import 'package:zpevnik/screens/user/settings.dart';

class UserMenu extends StatelessWidget {
  const UserMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return BottomFormSheet(
      title: 'Ostatní',
      contentPadding: EdgeInsets.zero,
      items: [
        IconItem(
          title: 'Nastavení',
          icon: Icons.settings,
          onTap: () => _doAndHide(context, () => _pushSettings(context)),
        ),
        IconItem(
          title: 'Webová verze',
          icon: Icons.language,
          onTap: () => _doAndHide(context, () => launch(proscholyUrl)),
        ),
        IconItem(
          title: 'Zpětná vazba',
          icon: Icons.feedback,
          onTap: () => _doAndHide(context, () => launch(isIos ? feedbackIOSUrl : feedbackAndroidUrl)),
        ),
        IconItem(
          title: 'Přidat píseň',
          icon: Icons.add,
          onTap: () => _doAndHide(context, () => launch(addSongUrl)),
        ),
        IconItem(
          title: 'O projektu',
          icon: Icons.info,
          onTap: () => _doAndHide(context, () => _pushAbout(context)),
        ),
      ],
    );
  }

  void _doAndHide(BuildContext context, Function() func) {
    Navigator.of(context).pop();

    func();
  }

  void _pushSettings(BuildContext context) => Navigator.of(context, rootNavigator: true).push(platformRouteBuilder(
        context,
        SettingsScreen(),
        types: [ProviderType.data],
      ));

  void _pushAbout(BuildContext context) =>
      Navigator.of(context, rootNavigator: true).push(platformRouteBuilder(context, AboutScreen()));
}
