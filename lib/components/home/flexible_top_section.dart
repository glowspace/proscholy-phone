import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/logo.dart';
import 'package:zpevnik/components/search/search_field.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/routing/router.dart';

const double _avatarRadius = 16;

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
                  color: theme.shadowColor.withOpacity(0.5 * (1 - expansion)),
                  spreadRadius: 0,
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: const SearchField(key: Key('search_field')),
          ),
        ),
        Align(
          alignment: Alignment(1, -expansion),
          child: Highlightable(
            onTap: () => context.push('/user'),
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            icon: const CircleAvatar(radius: _avatarRadius, child: Icon(Icons.person)),
          ),
        ),
      ]),
    );
  }
}
