import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:proscholy_common/components/bottom_sheet_section.dart';
import 'package:proscholy_common/components/song_lyric/externals/external.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/external.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/internet_connection.dart';

const _externalMinWidth = 320.0;
const _noInternetMessage =
    'Nahrávky jsou dostupné pouze přes internet. Zkontrolujte prosím připojení k${unbreakableSpace}internetu.';

class ExternalsWidget extends ConsumerWidget {
  final SongLyric songLyric;

  const ExternalsWidget({super.key, required this.songLyric});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final externals = songLyric.externals
        .where((external) => external.mediaType == MediaType.youtube || external.mediaType == MediaType.mp3)
        .toList();

    return Container(
      constraints: BoxConstraints(maxHeight: 2 / 3 * MediaQuery.sizeOf(context).height),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(kDefaultRadius)),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: BottomSheetSection(
        title: 'Nahrávky',
        children: [
          ref
              .watch(internetConnectionProvider)
              .when(
                data: (_) => LayoutBuilder(
                  builder: (_, constraints) => AlignedGridView.count(
                    primary: false,
                    padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                    crossAxisCount: max(1, (constraints.maxWidth / _externalMinWidth).floor()),
                    crossAxisSpacing: kDefaultPadding,
                    mainAxisSpacing: kDefaultPadding,
                    itemCount: externals.length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) => ExternalWidget(external: externals[index]),
                  ),
                ),
                error: (_, _) => const Padding(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Material(
                    color: Colors.transparent,
                    child: Text(_noInternetMessage, textAlign: TextAlign.center),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator.adaptive()),
              ),
        ],
      ),
    );
  }
}
