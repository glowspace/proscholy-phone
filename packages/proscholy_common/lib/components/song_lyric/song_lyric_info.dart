import 'package:flutter/material.dart';
import 'package:proscholy_common/components/bottom_sheet_section.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/song_lyric.dart';

class SongLyricInfo extends StatelessWidget {
  final SongLyric songLyric;

  const SongLyricInfo({super.key, required this.songLyric});

  @override
  Widget build(BuildContext context) {
    return BottomSheetSection(
      title: 'O písni',
      children: [
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          child: Text(songLyric.hymnology),
        ),
      ],
    );
  }
}
