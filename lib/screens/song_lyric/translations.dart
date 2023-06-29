import 'package:flutter/material.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_row.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';

class TranslationsScreen extends StatelessWidget {
  final SongLyric songLyric;

  const TranslationsScreen({super.key, required this.songLyric});

  @override
  Widget build(BuildContext context) {
    final songLyrics = songLyric.song.target!.songLyrics;

    final original =
        songLyrics.cast().firstWhere((songLyric) => songLyric.type == SongLyricType.original, orElse: () => null);

    final authorizedTranslations =
        songLyrics.where((songLyric) => songLyric.type == SongLyricType.authorizedTranslation);

    final translations = songLyrics.where((songLyric) => songLyric.type == SongLyricType.translation);

    return CustomScaffold(
      appBar: AppBar(leading: const CustomBackButton(), title: const Text('Překlady')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: kDefaultPadding),
              if (original != null) _buildSection(context, SongLyricType.original, [original]),
              if (authorizedTranslations.isNotEmpty)
                _buildSection(context, SongLyricType.authorizedTranslation, authorizedTranslations),
              if (translations.isNotEmpty) _buildSection(context, SongLyricType.translation, translations),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, SongLyricType songLyricType, Iterable<SongLyric> songLyrics) {
    final Color color;

    switch (songLyricType) {
      case SongLyricType.original:
        color = blue;
        break;
      case SongLyricType.authorizedTranslation:
        color = green;
        break;
      case SongLyricType.translation:
        color = red;
        break;
    }

    final theme = Theme.of(context);
    final textStyle = theme.textTheme.titleMedium
        ?.copyWith(color: ColorScheme.fromSeed(seedColor: color, brightness: theme.brightness).primary);

    return Container(
      padding: const EdgeInsets.only(bottom: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
            child: Text(songLyricType.description, style: textStyle),
          ),
          ...songLyrics.map((songLyric) => SongLyricRow(songLyric: songLyric, allowHighlight: true)),
        ],
      ),
    );
  }
}
