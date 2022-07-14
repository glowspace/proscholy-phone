import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/filters/filters_row.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_list_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/routes/arguments/search.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';
import 'package:zpevnik/utils/extensions.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final songLyricsProvider = context.read<AllSongLyricsProvider>();
    final searchScreenArguments = ModalRoute.of(context)?.settings.arguments as SearchScreenArguments?;

    final String title;

    if (searchScreenArguments?.songbook != null) {
      title = searchScreenArguments!.songbook!.name;
    } else if (searchScreenArguments?.playlist != null) {
      title = searchScreenArguments!.playlist!.name;
    } else {
      title = 'Vyhledávání';
    }

    return Scaffold(
      backgroundColor: theme.brightness.isLight ? theme.colorScheme.surface : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: kDefaultPadding),
            if (searchScreenArguments?.showSearchTitle ?? true)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding).copyWith(bottom: kDefaultPadding / 2),
                child: Text(title, style: theme.textTheme.titleLarge),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: SearchField(
                key: const Key('searchfield'),
                isInsideSearchScreen: true,
                onChanged: (searchText) =>
                    songLyricsProvider.search(searchText, songbook: searchScreenArguments?.songbook),
                onSubmitted: (_) => _maybePushMatchedSonglyric(context),
              ),
            ),
            const SizedBox(height: kDefaultPadding),
            Container(
              padding: const EdgeInsets.only(left: kDefaultPadding),
              child: const FiltersRow(),
            ),
            const SizedBox(height: kDefaultPadding),
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

      Navigator.of(context)
          .pushNamed('/song_lyric', arguments: SongLyricScreenArguments([songLyricsProvider.matchedById!], 0));
    }
  }
}
