import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/tags.dart';
import 'package:zpevnik/utils/extensions.dart';

const double _removablefilterRadius = 7;
const double _filterRadius = 32;

class FilterTag extends StatelessWidget {
  final Tag tag;
  final bool isRemovable;

  const FilterTag({
    super.key,
    required this.tag,
    this.isRemovable = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: isRemovable ? const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4) : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isRemovable ? _removablefilterRadius : _filterRadius),
        border: Border.all(color: theme.hintColor, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      // for background color must be wrapped in `Material`, when setting color of the `Container` highligh won't be visible
      child: Consumer(
        builder: (_, ref, child) => Material(
          borderRadius: BorderRadius.circular(isRemovable ? _removablefilterRadius : _filterRadius),
          color: isRemovable
              ? Colors.transparent
              : (ref.watch(selectedTagsByTypeProvider(tag.type).select((selectedTags) => selectedTags.contains(tag)))
                  ? theme.colorScheme.secondaryContainer
                  : Colors.transparent),
          child: child,
        ),
        child: Highlightable(
          highlightBackground: true,
          highlightColor: theme.colorScheme.primary.withAlpha(0x20),
          borderRadius: BorderRadius.circular(isRemovable ? _removablefilterRadius : _filterRadius),
          onTap: () => context.providers.read(selectedTagsProvider.notifier).toggleSelection(tag),
          padding: isRemovable
              ? const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 3)
              : const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: Text(tag.name, overflow: TextOverflow.ellipsis, maxLines: 1)),
              if (isRemovable) const SizedBox(width: kDefaultPadding / 2),
              if (isRemovable) const Icon(Icons.close, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
