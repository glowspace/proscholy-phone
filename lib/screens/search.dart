import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/filters/filters_row.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_list_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/song_lyrics.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final songLyricsProvider = context.read<AllSongLyricsProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: kDefaultPadding),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text('Vyhledávání', style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: kDefaultPadding / 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: SearchField(
                key: const Key('searchfield'),
                isInsideSearchScreen: true,
                onChanged: songLyricsProvider.search,
                onSubmitted: (_) => _maybePushMatchedSonglyric(context),
              ),
            ),
            const SizedBox(height: kDefaultPadding),
            Container(
              padding: const EdgeInsets.only(left: kDefaultPadding),
              child: const FiltersRow(),
            ),
            const SizedBox(height: kDefaultPadding / 2),
            const Expanded(child: SongLyricsListView<AllSongLyricsProvider>()),
          ],
        ),
      ),
    );
  }

  void _maybePushMatchedSonglyric(BuildContext context) {
    final songLyricsProvider = context.read<AllSongLyricsProvider>();

    if (songLyricsProvider.matchedById != null) {
      songLyricsProvider.addRecentSongLyric(songLyricsProvider.matchedById!);

      Navigator.pushNamed(context, '/song_lyric', arguments: songLyricsProvider.matchedById);
    }
  }
}
