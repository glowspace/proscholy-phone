import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class SearchResultsSectionTitle extends StatelessWidget {
  final String title;

  const SearchResultsSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(1.5 * kDefaultPadding, kDefaultPadding, 1.5 * kDefaultPadding, 0),
      child: Text(title, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary)),
    );
  }
}
