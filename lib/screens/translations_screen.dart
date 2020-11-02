import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/providers/selection_provider.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

class TranslationsScreen extends StatelessWidget with PlatformWidgetMixin {
  final SongLyric songLyric;

  const TranslationsScreen({Key key, this.songLyric}) : super(key: key);

  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Překlady'),
        ),
        child: _body(context),
      );

  @override
  Widget androidWidget(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Překlady'),
          shadowColor: AppTheme.shared.appBarDividerColor(context),
        ),
        body: _body(context),
      );

  Widget _body(BuildContext context) => SafeArea(
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

  Widget _section(BuildContext context, SongLyricType songLyricType, List<SongLyric> songLyrics) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding / 3),
              child: Text(songLyricType.description,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(color: songLyricType.color)),
            ),
            for (final songLyric in songLyrics)
              ChangeNotifierProvider(
                create: (_) => SelectionProvider(),
                child: SongLyricRow(songLyric: songLyric),
              ),
          ],
        ),
      );
}
