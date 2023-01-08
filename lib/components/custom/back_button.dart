import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HighlightableIconButton(
      padding: const EdgeInsets.all(kDefaultPadding).copyWith(left: 2.5 * kDefaultPadding),
      onTap: Navigator.of(context).maybePop,
      icon: const BackButtonIcon(),
    );
  }
}
