import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/recent_item_row.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/recent_items.dart';

class RecentSection extends ConsumerWidget {
  const RecentSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentItems = ref.watch(recentItemsProvider);

    return Section(
      insideTitle: 'POSLEDNÍ POLOŽKY',
      insideTitleIcon: Icons.access_time_outlined,
      insideTitleIconColor: green,
      margin: const EdgeInsets.symmetric(vertical: 2 / 3 * kDefaultPadding),
      children: [
        ListView.separated(
          primary: false,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: recentItems.length,
          itemBuilder: (_, index) => RecentItemRow(recentItem: recentItems[index]),
          separatorBuilder: (_, __) => const Divider(),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
}
