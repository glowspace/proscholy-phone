import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zpevnik/components/bottom_sheet_section.dart';
import 'package:zpevnik/components/song_lyric/externals/external.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/models/song_lyric.dart';

const _externalMinWidth = 320.0;

class ExternalsWidget extends StatelessWidget {
  final SongLyric songLyric;

  const ExternalsWidget({super.key, required this.songLyric});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final externals = songLyric.externals
        .where((external) => external.mediaType == MediaType.youtube || external.mediaType == MediaType.mp3)
        .toList();

    return Container(
      width: size.width,
      constraints: BoxConstraints(maxHeight: 2 / 3 * size.height),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(kDefaultRadius)),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: BottomSheetSection(
        title: 'Nahrávky',
        children: [
          AlignedGridView.count(
            primary: false,
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            crossAxisCount: max(1, (size.width / _externalMinWidth).floor()),
            crossAxisSpacing: kDefaultPadding,
            mainAxisSpacing: kDefaultPadding,
            itemCount: externals.length,
            shrinkWrap: true,
            itemBuilder: (_, index) => ExternalWidget(external: externals[index]),
          ),
        ],
      ),
    );
  }
}
