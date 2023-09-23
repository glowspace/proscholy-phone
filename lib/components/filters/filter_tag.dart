import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/tags.dart';
import 'package:zpevnik/utils/extensions.dart';

const double _removablefilterRadius = 7;
const double _filterRadius = 32;

class FilterTag extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final padding = isRemovable
        ? const EdgeInsets.only(left: kDefaultPadding)
        : const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2);

    final backgroundColor = theme.brightness.isLight ? const Color(0xfff2f1f6) : const Color(0xff15131d);
    final selectedBackgroundColor = theme.brightness.isLight ? const Color(0xffe4e2ec) : const Color(0xff3c3653);
    final removeBackgroundColor = theme.brightness.isLight ? const Color(0xffe9e4f5) : const Color(0xff1c1333);

    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: Text(tag.name, overflow: TextOverflow.ellipsis, maxLines: 1)),
        if (isRemovable) const SizedBox(width: kDefaultPadding / 2),
        if (isRemovable)
          Material(
            color: removeBackgroundColor,
            child: Highlightable(
              onTap: () => ref.read(selectedTagsProvider.notifier).toggleSelection(tag),
              highlightBackground: true,
              highlightColor: theme.colorScheme.primary.withAlpha(0x20),
              padding: const EdgeInsets.all(kDefaultPadding / 2).copyWith(left: kDefaultPadding / 4),
              child: const Icon(Icons.close, size: 14),
            ),
          ),
      ],
    );

    if (isToggable) {
      child = Highlightable(
        highlightBackground: true,
        highlightColor: theme.colorScheme.primary.withAlpha(0x10),
        borderRadius: BorderRadius.circular(_filterRadius),
        onTap: () => ref.read(selectedTagsProvider.notifier).toggleSelection(tag),
        padding: padding,
        child: child,
      );
    }

    return Container(
      margin: isToggable ? null : const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
      padding: isToggable ? null : padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isRemovable ? _removablefilterRadius : _filterRadius),
        border: isToggable ? Border.all(color: theme.hintColor, width: 0.5) : null,
        color: isRemovable
            ? backgroundColor
            : (ref.watch(selectedTagsByTypeProvider(tag.type).select((selectedTags) => selectedTags.contains(tag)))
                ? selectedBackgroundColor
                : null),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
