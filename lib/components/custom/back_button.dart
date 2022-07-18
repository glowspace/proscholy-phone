import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/navigation.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Highlightable(
      child: const BackButtonIcon(),
      padding: const EdgeInsets.all(kDefaultPadding).copyWith(left: 2.5 * kDefaultPadding),
      onTap: NavigationProvider.navigatorOf(context).maybePop,
    );
  }
}
