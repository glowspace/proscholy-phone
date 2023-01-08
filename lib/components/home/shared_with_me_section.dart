import 'package:flutter/material.dart';
import 'package:zpevnik/components/open_all_button.dart';
import 'package:zpevnik/components/section.dart';

class SharedWithMeSection extends StatelessWidget {
  const SharedWithMeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Section(
      title: Text('Sdíleno se mnou', style: Theme.of(context).textTheme.titleLarge),
      child: Row(
        children: [],
      ),
      action: OpenAllButton(title: 'Všechny sdílené'),
    );
  }
}
