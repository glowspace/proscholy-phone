import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/screens/about_screen.dart';

class UserMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _option('Nastavení', Icons.settings, null),
            _option('Webová verze', Icons.language, () => _open('https://zpevnik.proscholy.cz')),
            _option(
                'Zpětná vazba',
                Icons.feedback,
                () => _open(
                    'https://docs.google.com/forms/d/e/1FAIpQLSfI0143gkLBtMbWQnSa9nzpOoBNMokZrOIS5mUreSR41E_B7A/viewform')),
            _option('Přidat píseň', Icons.add, () => _open('https://forms.gle/AYXXxkWtDHQQ13856')),
            _option(
              'O projektu',
              Icons.info,
              () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AboutScreen()),
              ),
            ),
          ],
        ),
      );

  Widget _option(String title, IconData icon, Function() action) => GestureDetector(
        onTap: action,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: kDefaultPadding),
                child: Icon(icon),
              ),
              Text(title),
            ],
          ),
        ),
      );

  void _open(String url) async => await launch(url);
}
