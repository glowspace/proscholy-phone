import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/components/filters/filter_tag.dart';

class FiltersSection extends StatelessWidget {
  final String title;
  final List<Tag> tags;
  final bool isLast;

  const FiltersSection({
    super.key,
    required this.title,
    required this.tags,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              const SizedBox(height: kDefaultPadding),
              Wrap(
                spacing: kDefaultPadding / 2,
                runSpacing: kDefaultPadding / 2,
                children: tags.map((tag) => FilterTag(tag: tag, isToggable: true)).toList(),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(thickness: 1, color: theme.colorScheme.outlineVariant),
      ],
    );
  }
}
