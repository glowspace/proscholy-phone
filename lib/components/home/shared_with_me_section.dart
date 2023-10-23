import 'package:flutter/material.dart';
import 'package:zpevnik/components/open_all_button.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';

class SharedWithMeSection extends StatelessWidget {
  const SharedWithMeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Section(
      outsideTitle: 'Sdíleno se mnou',
      outsideTitleLarge: true,
      margin: EdgeInsets.symmetric(vertical: 2 / 3 * kDefaultPadding),
      action: OpenAllButton(title: 'Zobrazit vše'),
      children: [],
    );
  }
}
