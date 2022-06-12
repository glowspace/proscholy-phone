import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Highlightable(
      child: const BackButtonIcon(),
      onTap: Navigator.of(context).maybePop,
    );
  }
}
