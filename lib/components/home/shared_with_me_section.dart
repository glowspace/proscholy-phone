import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/section.dart';

const double _navigateNextIconSize = 20;

class SharedWithMeSection extends StatelessWidget {
  const SharedWithMeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Section(
      title: Text('Sdíleno se mnou', style: Theme.of(context).textTheme.titleLarge),
      child: Row(
        children: [],
      ),
      action: Highlightable(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Všechny sdílené', style: Theme.of(context).textTheme.bodySmall),
            const Icon(Icons.navigate_next, size: _navigateNextIconSize),
          ],
        ),
      ),
    );
  }
}
