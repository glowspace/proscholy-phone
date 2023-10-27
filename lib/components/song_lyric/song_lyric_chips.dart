import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zpevnik/components/selected_displayable_item_index.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_chip.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_files.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_tags.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/components/translations.dart';

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
        if (songLyric.hasTags || songLyric.hasSongbooks)
          SongLyricChip(
            text: songLyric.hasTags ? (songLyric.hasSongbooks ? 'Štítky, zpěvníky' : 'Štítky') : 'Zpěvníky',
            icon: FontAwesomeIcons.tags,
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (_) => SongLyricTags(songLyric: songLyric),
            ),
          ),
      ],
    );
  }
}
