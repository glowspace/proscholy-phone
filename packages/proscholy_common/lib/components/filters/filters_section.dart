import 'package:flutter/material.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/tag.dart';
import 'package:proscholy_common/components/filters/filter_tag.dart';

class FiltersSection extends StatelessWidget {
  final String title;
  final List<Tag> tags;

  const FiltersSection({super.key, required this.title, required this.tags});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ExpansionTile(
      title: Text(title, style: theme.textTheme.titleLarge),
      shape: const Border(),
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      tilePadding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      childrenPadding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      children: [
        Wrap(
          spacing: kDefaultPadding / 2,
          runSpacing: kDefaultPadding / 2,
          children: tags.map((tag) => FilterTag(tag: tag)).toList(),
        ),
      ],
    );
  }
}
