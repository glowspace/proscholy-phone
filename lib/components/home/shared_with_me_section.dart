import 'package:flutter/material.dart';
import 'package:zpevnik/components/open_all_button.dart';
import 'package:zpevnik/components/section.dart';

class SharedWithMeSection extends StatelessWidget {
  const SharedWithMeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      title: Text('Sdíleno se mnou', style: Theme.of(context).textTheme.titleLarge),
      action: const OpenAllButton(title: 'Všechny sdílené'),
      child: const Row(
        children: [],
      ),
    );
  }
}
