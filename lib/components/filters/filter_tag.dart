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
  final bool isToggable;
  final bool isRemovable;

  const FilterTag({
    super.key,
    required this.tag,
    this.isToggable = false,
    this.isRemovable = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final padding = isRemovable
        ? const EdgeInsets.only(left: kDefaultPadding)
        : const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2);

    final selectedBackgroundColor = theme.colorScheme.secondaryContainer;
    final removeBackgroundColor = theme.colorScheme.primaryContainer;

    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: Text(tag.name, overflow: TextOverflow.ellipsis, maxLines: 1)),
        if (isRemovable) const SizedBox(width: kDefaultPadding / 2),
        if (isRemovable)
          Material(
            color: removeBackgroundColor,
            child: Highlightable(
              onTap: () => context.providers.read(selectedTagsProvider.notifier).toggleSelection(tag),
              highlightBackground: true,
              highlightColor: theme.colorScheme.primary.withAlpha(0x20),
              padding: const EdgeInsets.all(2 * kDefaultPadding / 3).copyWith(left: kDefaultPadding / 4),
              child: const Icon(Icons.close, size: 14),
            ),
          ),
      ],
    );

    if (isToggable) {
      child = Highlightable(
        highlightBackground: true,
        highlightColor: theme.colorScheme.primary.withAlpha(0x20),
        borderRadius: BorderRadius.circular(_filterRadius),
        onTap: () => context.providers.read(selectedTagsProvider.notifier).toggleSelection(tag),
        padding: padding,
        child: child,
      );
    }

    return Container(
      margin: isToggable ? null : const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isRemovable ? _removablefilterRadius : _filterRadius),
        border: isToggable ? Border.all(color: theme.hintColor, width: 0.5) : null,
      ),
      clipBehavior: Clip.antiAlias,
      // for background color must be wrapped in `Material`, when setting color of the `Container` highligh won't be visible
      child: Consumer(
        builder: (_, ref, child) => Material(
          borderRadius: BorderRadius.circular(isRemovable ? _removablefilterRadius : _filterRadius),
          color: isRemovable
              ? selectedBackgroundColor
              : (ref.watch(selectedTagsByTypeProvider(tag.type).select((selectedTags) => selectedTags.contains(tag)))
                  ? selectedBackgroundColor
                  : Colors.transparent),
          child: child,
        ),
        child: Padding(padding: isToggable ? EdgeInsets.zero : padding, child: child),
      ),
    );
  }
}
