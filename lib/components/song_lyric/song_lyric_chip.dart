import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class SongLyricChip extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()? onTap;

  const SongLyricChip({super.key, required this.text, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultRadius),
        border: Border.all(color: theme.dividerColor, width: 0.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kDefaultRadius),
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 14),
              const SizedBox(width: kDefaultPadding / 2),
              Text(text, style: theme.textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}
