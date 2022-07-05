import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Highlightable(
      child: const Icon(Icons.close),
      padding: const EdgeInsets.all(kDefaultPadding),
      onTap: Navigator.of(context).maybePop,
    );
  }
}
