import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proscholy_common/components/bottom_sheet_section.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/external.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/utils/extensions.dart';

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
          HighlightableWidget(
            onTap: () => file.mediaType == MediaType.pdf
                ? context.popAndPush('/song_lyric/pdf', arguments: file)
                : context.popAndPush('/song_lyric/jpg', arguments: file),
            padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding / 2),
            child: Row(children: [
              switch (file.mediaType) {
                MediaType.pdf => const FaIcon(FontAwesomeIcons.solidFilePdf),
                MediaType.jpg => const FaIcon(FontAwesomeIcons.solidFileLines),
                _ => throw UnsupportedError('unsupported media type'),
              },
              const SizedBox(width: kDefaultPadding),
              Expanded(child: Text(file.name)),
            ]),
          ),
      ],
    );
  }
}
