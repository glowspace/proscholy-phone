import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';

class FilterTag extends StatelessWidget {
  final Tag tag;
  final bool isRemovable;

  const FilterTag({Key? key, required this.tag, this.isRemovable = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final padding = isRemovable
        ? const EdgeInsets.only(left: kDefaultPadding)
        : const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: theme.colorScheme.primary.withAlpha(0x20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tag.name),
          if (isRemovable) const SizedBox(width: kDefaultPadding / 2),
          if (isRemovable)
            Highlightable(
              child: Container(
                padding: const EdgeInsets.all(kDefaultPadding / 2).copyWith(left: kDefaultPadding / 4),
                color: theme.colorScheme.primary.withAlpha(0x30),
                child: const Icon(Icons.close, size: 16),
              ),
            ),
        ],
      ),
    );
  }
}
