import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/screens/components/data_container.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

class TranslationsScreen extends StatelessWidget with PlatformWidgetMixin {
  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('Překlady')),
        child: _body(context),
      );

  @override
  Widget androidWidget(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Překlady'),
          shadowColor: AppTheme.shared.appBarDividerColor(context),
          brightness: AppThemeNew.of(context).brightness,
        ),
        body: _body(context),
      );

  Widget _body(BuildContext context) {
    final songLyric = DataContainer.of<SongLyric>(context).data;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (songLyric.original.isNotEmpty) _section(context, SongLyricType.original, songLyric.original),
              if (songLyric.authorizedTranslations.isNotEmpty)
                _section(context, SongLyricType.authorizedTranslation, songLyric.authorizedTranslations),
              if (songLyric.translations.isNotEmpty)
                _section(context, SongLyricType.translation, songLyric.translations),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, SongLyricType songLyricType, List<SongLyric> songLyrics) => Container(
        padding: EdgeInsets.only(bottom: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(
                songLyricType.description,
                style: AppThemeNew.of(context).subTitleTextStyle.copyWith(color: songLyricType.color),
              ),
            ),
            for (final songLyric in songLyrics) SongLyricRow(songLyric: songLyric),
          ],
        ),
      );
}
