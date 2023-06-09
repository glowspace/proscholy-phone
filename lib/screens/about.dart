import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/utils/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textStyle = theme.textTheme.bodyMedium;
    final highlightedStyle = textStyle?.copyWith(color: theme.colorScheme.primary);
    final boldStyle = textStyle?.copyWith(fontWeight: FontWeight.bold);

    final linkOpener = TapGestureRecognizer()..onTap = () => launch(context, proscholyUrl);

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text('O projektu', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding),
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
        ),
      ),
    );
  }
}
