import 'package:flutter/material.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/components/logo.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/utils/extensions.dart';

class TopSection extends StatelessWidget {
  const TopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2 / 3 * kDefaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Logo(showFullName: false),
          const Spacer(),
          HighlightableWidget(
            onTap: () => context.push('/settings'),
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
