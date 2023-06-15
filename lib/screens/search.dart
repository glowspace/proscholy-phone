import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/filters/filters.dart';
import 'package:zpevnik/components/filters/filters_row.dart';
import 'package:zpevnik/components/search/search_field.dart';
import 'package:zpevnik/components/search/search_song_lyrics_list_view.dart';
import 'package:zpevnik/components/split_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/search.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';
import 'package:zpevnik/utils/extensions.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: kDefaultPadding),
        SearchField(
          key: const Key('searchfield'),
          isInsideSearchScreen: true,
          onChanged: (searchText) => ref.read(searchTextProvider.notifier).state = searchText,
          onSubmitted: (_) => _maybePushMatchedSonglyric(context),
        ),
        Container(
          padding: const EdgeInsets.only(left: kDefaultPadding),
          child: const FiltersRow(),
        ),
        const SizedBox(height: kDefaultPadding),
        const Expanded(child: SearchSongLyricsListView()),
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
              body: const SafeArea(child: FiltersWidget()),
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
    // final songLyricsProvider = context.read<AllSongLyricsProvider>();

    // if (songLyricsProvider.matchedById != null) {
    //   songLyricsProvider.addRecentSongLyric(songLyricsProvider.matchedById!);

    //   Navigator.of(context)
    //       .pushNamed('/song_lyric', arguments: SongLyricScreenArguments([songLyricsProvider.matchedById!], 0));
    // }
  }
}
