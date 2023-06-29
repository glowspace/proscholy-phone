import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Highlightable(
      padding: const EdgeInsets.all(kDefaultPadding).copyWith(left: 2.5 * kDefaultPadding),
      onTap: context.pop,
      icon: const BackButtonIcon(),
    );
  }
}
