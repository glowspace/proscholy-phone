import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_chip.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_files.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_tags.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/screens/song_lyric/translations.dart';

class SongLyricChips extends StatelessWidget {
  final SongLyric songLyric;

  const SongLyricChips({super.key, required this.songLyric});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      child: Wrap(
        spacing: kDefaultPadding / 2,
        runSpacing: kDefaultPadding / 4,
        children: [
          if (songLyric.hasFiles)
            SongLyricChip(text: 'Noty, materiály', icon: FontAwesomeIcons.music, onTap: () => _showFiles(context)),
          if (songLyric.hasTranslations)
            SongLyricChip(text: 'Aranže, překlady', icon: Icons.translate, onTap: () => _showTranslations(context)),
          SongLyricChip(text: 'Štítky, zpěvníky', icon: FontAwesomeIcons.tags, onTap: () => _showTags(context)),
        ],
      ),
    );
  }

  void _showFiles(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
      builder: (context) => SongLyricFilesWidget(songLyric: songLyric),
    );
  }

  void _showTranslations(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
      builder: (context) => TranslationsScreen(songLyric: songLyric),
    );
  }

  void _showTags(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
      builder: (context) => SongLyricTags(songLyric: songLyric),
    );
  }
}
