import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

class AboutScreen extends StatelessWidget with PlatformWidgetMixin {
  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('O projektu'),
        ),
        child: _body(context),
      );

  @override
  Widget androidWidget(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('O projektu'),
          shadowColor: AppTheme.shared.appBarDividerColor(context),
        ),
        body: _body(context),
      );

  Widget _body(BuildContext context) => Container(
        padding: EdgeInsets.all(kDefaultPadding),
        child: RichText(
          text: TextSpan(text: 'Zpěvník ', style: Theme.of(context).textTheme.bodyText1, children: [
            TextSpan(
                text: 'ProScholy.cz',
                style: TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()..onTap = () => launch('https://zpevnik.proscholy.cz')),
            TextSpan(
              text:
                  ', který přichází na${unbreakableSpace}pomoc všem scholám, křesťanským kapelám, společenstvím a${unbreakableSpace}všem, kdo se chtějí modlit hudbou!\n\nProjekt vzniká se svolením ',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextSpan(
              text: 'České biskupské konference',
              style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text:
                  '.\n\nDalší informace o${unbreakableSpace}stavu a${unbreakableSpace}rozvoji projektu naleznete na$unbreakableSpace',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextSpan(
                text: 'https://zpevnik.proscholy.cz',
                style: TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()..onTap = () => launch('https://zpevnik.proscholy.cz')),
            TextSpan(text: '.'),
          ]),
        ),
      );
}
