import 'package:flutter/material.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';

class RecentSection extends StatelessWidget {
  const RecentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      insideTitle: 'POSLEDNÍ POLOŽKY',
      insideTitleIcon: Icons.access_time_outlined,
      insideTitleIconColor: green,
      padding: const EdgeInsets.all(kDefaultPadding),
      margin: const EdgeInsets.symmetric(vertical: 2 / 3 * kDefaultPadding),
      children: [],
    );
  }
}
