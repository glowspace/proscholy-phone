import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/platform/components/scaffold.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';
import 'package:zpevnik/theme.dart';

class TranslationsScreen extends StatelessWidget {
  final SongLyric songLyric;

  const TranslationsScreen({Key? key, required this.songLyric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songLyrics = context.watch<DataProvider>().songsSongLyrics(songLyric.songId ?? -1);

    final original = songLyrics?.where((songLyric) => songLyric.type == SongLyricType.original);

    final authorizedTranslations =
        songLyrics?.where((songLyric) => songLyric.type == SongLyricType.authorizedTranslation);

    final translations = songLyrics?.where((songLyric) => songLyric.type == SongLyricType.translation);

    return PlatformScaffold(
      title: 'Překlady',
      body: Container(
        padding: EdgeInsets.only(top: kDefaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (original != null && original.isNotEmpty) _buildSection(context, SongLyricType.original, original),
              if (authorizedTranslations != null && authorizedTranslations.isNotEmpty)
                _buildSection(context, SongLyricType.authorizedTranslation, authorizedTranslations),
              if (translations != null && translations.isNotEmpty)
                _buildSection(context, SongLyricType.translation, translations),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, SongLyricType songLyricType, Iterable<SongLyric> songLyrics) {
    final textStyle = AppTheme.of(context).subTitleTextStyle?.copyWith(color: songLyricType.color);

    return Container(
      padding: EdgeInsets.only(bottom: kDefaultPadding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(songLyricType.description, style: textStyle),
          ),
          for (final songLyric in songLyrics) SongLyricRow(songLyric: songLyric, translationSongLyric: this.songLyric),
        ],
      ),
    );
  }
}
