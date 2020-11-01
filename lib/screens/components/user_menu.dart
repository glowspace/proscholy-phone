import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/screens/about_screen.dart';
import 'package:zpevnik/screens/components/higlightable_row.dart';

class UserMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HighlightableRow(title: 'Nastavení', icon: Icons.settings, onPressed: null),
            HighlightableRow(
                title: 'Webová verze', icon: Icons.language, onPressed: () => launch('https://zpevnik.proscholy.cz')),
            HighlightableRow(
                title: 'Zpětná vazba',
                icon: Icons.feedback,
                onPressed: () => launch(
                    'https://docs.google.com/forms/d/e/1FAIpQLSfI0143gkLBtMbWQnSa9nzpOoBNMokZrOIS5mUreSR41E_B7A/viewform')),
            HighlightableRow(
                title: 'Přidat píseň', icon: Icons.add, onPressed: () => launch('https://forms.gle/AYXXxkWtDHQQ13856')),
            HighlightableRow(
              title: 'O projektu',
              icon: Icons.info,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AboutScreen()),
              ),
            ),
          ],
        ),
      );
}
