import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zpevnik/components/bottom_sheet_section.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/routing/router.dart';

class SongLyricFilesWidget extends StatelessWidget {
  final SongLyric songLyric;

  const SongLyricFilesWidget({super.key, required this.songLyric});

  @override
  Widget build(BuildContext context) {
    final files = songLyric.files;

    return BottomSheetSection(
      title: 'Noty',
      childrenPadding: false,
      children: [
        for (final file in files)
          Highlightable(
            onTap: () => file.mediaType == MediaType.pdf
                ? context.popAndPush('/pdf', extra: file)
                : context.popAndPush('/jpg', extra: file),
            padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding / 2),
            child: Row(children: [
              const FaIcon(FontAwesomeIcons.filePdf),
              const SizedBox(width: kDefaultPadding),
              Expanded(child: Text(file.name)),
            ]),
          ),
      ],
    );
  }
}
