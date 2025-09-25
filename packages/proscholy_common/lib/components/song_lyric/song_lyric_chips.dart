import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proscholy_common/components/selected_displayable_item_arguments.dart';
import 'package:proscholy_common/components/song_lyric/song_lyric_chip.dart';
import 'package:proscholy_common/components/song_lyric/song_lyric_files.dart';
import 'package:proscholy_common/components/song_lyric/song_lyric_info.dart';
import 'package:proscholy_common/components/song_lyric/song_lyric_tags.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/components/translations.dart';

class SongLyricChips extends StatelessWidget {
  final SongLyric songLyric;

  const SongLyricChips({super.key, required this.songLyric});

  @override
  Widget build(BuildContext context) {
    final fontSizeScale = MediaQuery.textScaleFactorOf(context);

    final displayableItemArgumentsNotifier = SelectedDisplayableItemArguments.of(context);

    return Wrap(
      spacing: fontSizeScale * kDefaultPadding / 2,
      runSpacing: fontSizeScale * kDefaultPadding / 4,
      children: [
        if (songLyric.hasFiles)
          SongLyricChip(
            text: 'Noty',
            icon: FontAwesomeIcons.music,
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (_) => SongLyricFilesWidget(songLyric: songLyric),
            ),
          ),
        if (songLyric.hasTranslations)
          SongLyricChip(
            text: 'Překlady',
            icon: Icons.translate,
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (_) {
                if (displayableItemArgumentsNotifier != null) {
                  return SelectedDisplayableItemArguments(
                    displayableItemArgumentsNotifier: displayableItemArgumentsNotifier,
                    child: TranslationsSheet(songLyric: songLyric),
                  );
                }

                return TranslationsSheet(songLyric: songLyric);
              },
            ),
          ),
        if (isZPS && (songLyric.hasTags || songLyric.hasSongbooks))
          SongLyricChip(
            text: songLyric.hasTags ? (songLyric.hasSongbooks ? 'Štítky, zpěvníky' : 'Štítky') : 'Zpěvníky',
            icon: FontAwesomeIcons.tags,
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (_) => SongLyricTags(songLyric: songLyric),
            ),
          ),
        if ((isEZ || isEK) && songLyric.hasHymnology)
          SongLyricChip(
            text: 'O písni',
            icon: Icons.info,
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (_) => SongLyricInfo(songLyric: songLyric),
            ),
          ),
      ],
    );
  }
}
