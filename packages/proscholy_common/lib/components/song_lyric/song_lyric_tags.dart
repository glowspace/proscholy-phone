import 'package:flutter/material.dart';
import 'package:proscholy_common/components/bottom_sheet_section.dart';
import 'package:proscholy_common/components/song_lyric/song_lyric_tag.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/views/tag.dart';

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
          children: songLyric.tags.where((tag) => tag.isSupported).map((tag) => SongLyricTag(tag: tag)).toList(),
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
