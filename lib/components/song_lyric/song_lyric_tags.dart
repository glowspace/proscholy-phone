import 'package:flutter/material.dart';
import 'package:zpevnik/components/bottom_sheet_section.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_tag.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';

class SongLyricTags extends StatelessWidget {
  final SongLyric songLyric;

  const SongLyricTags({super.key, required this.songLyric});

  @override
  Widget build(BuildContext context) {
    return BottomSheetSection(
      title: 'Štítky',
      children: [
        Wrap(
          spacing: kDefaultPadding / 2,
          runSpacing: kDefaultPadding / 2,
          children: songLyric.tags.where((tag) => tag.type.isSupported).map((tag) => SongLyricTag(tag: tag)).toList(),
        ),
        const SizedBox(height: kDefaultPadding / 2),
        Wrap(
          spacing: kDefaultPadding / 2,
          runSpacing: kDefaultPadding / 2,
          children:
              songLyric.songbookRecords.map((songbookRecord) => SongLyricTag(songbookRecord: songbookRecord)).toList(),
        ),
      ],
    );
  }
}
