import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/components/bottom_sheet_section.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_section_title.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_row.dart';
import 'package:zpevnik/models/song_lyric.dart';

class TranslationsSheet extends StatelessWidget {
  final SongLyric songLyric;

  const TranslationsSheet({super.key, required this.songLyric});

  @override
  Widget build(BuildContext context) {
    final songLyrics = songLyric.song.target!.songLyrics;

    final original = songLyrics.firstWhereOrNull((songLyric) => songLyric.type == SongLyricType.original);

    final authorizedTranslations =
        songLyrics.where((songLyric) => songLyric.type == SongLyricType.authorizedTranslation);

    final translations = songLyrics.where((songLyric) => songLyric.type == SongLyricType.translation);

    return BottomSheetSection(
      title: 'Překlady',
      childrenPadding: false,
      children: [
        if (original != null) _buildSection(context, SongLyricType.original, [original]),
        if (authorizedTranslations.isNotEmpty)
          _buildSection(context, SongLyricType.authorizedTranslation, authorizedTranslations),
        if (translations.isNotEmpty) _buildSection(context, SongLyricType.translation, translations),
      ],
    );
  }

  Widget _buildSection(BuildContext context, SongLyricType songLyricType, Iterable<SongLyric> songLyrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SongLyricsSectionTitle(title: songLyricType.description),
        for (final songLyric in songLyrics) SongLyricRow(songLyric: songLyric)
      ],
    );
  }
}
