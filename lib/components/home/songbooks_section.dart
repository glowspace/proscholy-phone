import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/open_all_button.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/components/songbook/songbook_row.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/songbooks.dart';
import 'package:zpevnik/routing/router.dart';

const _maxShowingSongbooks = 3;

class SongbooksSection extends ConsumerWidget {
  const SongbooksSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showingSongbooks = ref.watch(songbooksProvider).sublist(0, _maxShowingSongbooks);

    return Section(
      outsideTitle: 'Zpěvníky',
      outsideTitleLarge: true,
      margin: const EdgeInsets.symmetric(vertical: 2 / 3 * kDefaultPadding),
      action: OpenAllButton(
        title: 'Zobrazit vše',
        onTap: () => context.push('/songbooks'),
      ),
      children: [
        ListView.separated(
          primary: false,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: showingSongbooks.length,
          itemBuilder: (_, index) => SongbookRow(songbook: showingSongbooks[index]),
          separatorBuilder: (_, __) => const Divider(),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
}
