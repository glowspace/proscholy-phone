import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zpevnik/components/open_all_button.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/components/songbook/songbooks_grid_view.dart';
import 'package:zpevnik/components/songbook/songbooks_list_view.dart';
import 'package:zpevnik/providers/songbooks.dart';
import 'package:zpevnik/utils/extensions.dart';

const _maxShowingSongbooksPhone = 3;
const _maxShowingSongbooksTablet = 4;

class SongbooksSection extends ConsumerWidget {
  const SongbooksSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showingSongbooks = ref
        .watch(songbooksProvider)
        .sublist(0, MediaQuery.of(context).isTablet ? _maxShowingSongbooksTablet : _maxShowingSongbooksPhone);

    return Section(
      title: Text('Zpěvníky', style: Theme.of(context).textTheme.titleLarge),
      action: OpenAllButton(
        title: 'Všechny zpěvníky',
        onTap: () => context.push('/songbooks'),
      ),
      child: MediaQuery.of(context).isTablet
          ? SongbooksGridView(songbooks: showingSongbooks, shrinkWrap: true, isCrossAxisCountMultipleOfTwo: true)
          : SongbooksListView(songbooks: showingSongbooks, shrinkWrap: true),
    );
  }
}
