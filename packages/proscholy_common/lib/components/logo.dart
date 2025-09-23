import 'package:flutter/material.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/theme.dart';
import 'package:proscholy_common/utils/extensions.dart';

class Logo extends StatelessWidget {
  final bool showFullName;

  const Logo({super.key, this.showFullName = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/logos/logo.png'),
        const SizedBox(width: kDefaultPadding),
        Text('Zpěvník', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class GlowspaceLogo extends StatelessWidget {
  final bool showDescription;

  const GlowspaceLogo({super.key, this.showDescription = false});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness.isLight ? lightTitleColor : darkTitleColor;
    final text = showDescription ? 'Projekt komunity Glow Space' : 'Glow Space';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/logos/gs_logo.png'),
        const SizedBox(width: kDefaultPadding),
        Text(text, style: TextStyle(fontSize: 17, color: textColor, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
