import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HighlightableIconButton(
      padding: const EdgeInsets.all(kDefaultPadding).copyWith(left: 2 * kDefaultPadding),
      onTap: Navigator.of(context).maybePop,
      icon: const Icon(Icons.close),
    );
  }
}
