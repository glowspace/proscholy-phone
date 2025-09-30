import 'package:flutter/material.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/components/logo.dart';
import 'package:proscholy_common/components/search/search_field.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/utils/extensions.dart';

class FlexibleTopSection extends StatelessWidget {
  const FlexibleTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;
    final expansion = (settings.currentExtent - settings.minExtent) / (settings.maxExtent - settings.minExtent);

    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Stack(children: [
        Opacity(opacity: expansion, child: const Logo(showFullName: false)),
        Align(
          alignment: Alignment(0, expansion),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kDefaultRadius),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.5 * (1 - expansion)),
                  spreadRadius: 0,
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: const SearchField(key: Key('search_field'), isHome: true),
          ),
        ),
        Align(
          alignment: Alignment(1, -expansion),
          child: HighlightableWidget(
            onTap: () => context.push('/settings'),
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            icon: const Icon(Icons.settings),
          ),
        ),
      ]),
    );
  }
}
