import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/navigation.dart';

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Highlightable(
      child: const Icon(Icons.close),
      padding: const EdgeInsets.all(kDefaultPadding).copyWith(left: 2 * kDefaultPadding),
      onTap: NavigationProvider.navigatorOf(context).maybePop,
    );
  }
}
