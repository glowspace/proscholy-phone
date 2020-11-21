import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

class AboutScreen extends StatelessWidget with PlatformWidgetMixin {
  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('O projektu')),
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

  Widget _body(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText1;
    final highlightedStyle = textStyle.copyWith(color: Colors.blue);
    final boldStyle = textStyle.copyWith(fontWeight: FontWeight.bold);

    final linkOpener = TapGestureRecognizer()..onTap = () => launch(proscholyUrl);

    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      child: RichText(
        text: TextSpan(
          text: 'Zpěvník ',
          style: textStyle,
          children: [
            TextSpan(text: 'ProScholy.cz', style: highlightedStyle, recognizer: linkOpener),
            TextSpan(
              text:
                  ', který přichází na${unbreakableSpace}pomoc všem scholám, křesťanským kapelám, společenstvím a${unbreakableSpace}všem, kdo se chtějí modlit hudbou!\n\nProjekt vzniká se svolením ',
              style: textStyle,
            ),
            TextSpan(text: 'České biskupské konference', style: boldStyle),
            TextSpan(
              text:
                  '.\n\nDalší informace o${unbreakableSpace}stavu a${unbreakableSpace}rozvoji projektu naleznete na$unbreakableSpace',
              style: textStyle,
            ),
            TextSpan(text: proscholyUrl, style: highlightedStyle, recognizer: linkOpener),
            TextSpan(text: '.', style: textStyle),
          ],
        ),
      ),
    );
  }
}
