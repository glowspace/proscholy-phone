import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/extensions.dart';

class Logo extends StatelessWidget {
  final bool showFullName;

  const Logo({Key? key, this.showFullName = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness.isLight ? lightTitleColor : darkTitleColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/logos/logo.png'),
        const SizedBox(width: kDefaultPadding),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Zpěvník', style: GoogleFonts.roboto(fontSize: 34, color: textColor, fontWeight: FontWeight.w700)),
            if (showFullName)
              Text('ProScholy.cz',
                  style: GoogleFonts.roboto(fontSize: 16, color: textColor, fontWeight: FontWeight.w400)),
          ],
        )
      ],
    );
  }
}

class GlowspaceLogo extends StatelessWidget {
  final bool showDescription;

  const GlowspaceLogo({Key? key, this.showDescription = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness.isLight ? lightTitleColor : darkTitleColor;
    final text = showDescription ? 'Projekt komunity Glow Space' : 'Glow Space';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/logos/gs_logo.png'),
        const SizedBox(width: kDefaultPadding),
        Text(text, style: GoogleFonts.roboto(fontSize: 17, color: textColor, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
