import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class SongLyricsSectionTitle extends StatelessWidget {
  final String title;

  const SongLyricsSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(1.5 * kDefaultPadding, 0, 1.5 * kDefaultPadding, 0),
      child: Text(title.toUpperCase(), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary)),
    );
  }
}
