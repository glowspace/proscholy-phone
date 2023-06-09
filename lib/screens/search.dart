import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/filters/filters.dart';
import 'package:zpevnik/components/filters/filters_row.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_list_view.dart';
import 'package:zpevnik/components/split_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';
import 'package:zpevnik/utils/extensions.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final songLyricsProvider = context.read<AllSongLyricsProvider>();

    final child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: kDefaultPadding),
        SearchField(
          key: const Key('searchfield'),
          isInsideSearchScreen: true,
          onChanged: (searchText) => songLyricsProvider.search(searchText),
          onSubmitted: (_) => _maybePushMatchedSonglyric(context),
        ),
        Container(
          padding: const EdgeInsets.only(left: kDefaultPadding),
          child: const FiltersRow(),
        ),
        const SizedBox(height: kDefaultPadding),
        const Expanded(child: SongLyricsListView<AllSongLyricsProvider>()),
      ],
    );

    final mediaQuery = MediaQuery.of(context);

    if (mediaQuery.isTablet && mediaQuery.isLandscape) {
      return Scaffold(
        backgroundColor: theme.brightness.isLight ? theme.colorScheme.surface : null,
        body: SafeArea(
          child: SplitView(
            subChild: Scaffold(
              backgroundColor: theme.brightness.isLight ? theme.colorScheme.surface : null,
              // body: SafeArea(child: FiltersWidget(tagsSections: songLyricsProvider.tagsSections)),
            ),
            child: child,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.brightness.isLight ? theme.colorScheme.surface : null,
      body: SafeArea(child: child),
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
