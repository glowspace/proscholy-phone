import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/filters/filters_row.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_list_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/navigation.dart';
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

    final child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: kDefaultPadding),
        SearchField(
          key: const Key('searchfield'),
          isInsideSearchScreen: true,
          onChanged: (searchText) => songLyricsProvider.search(searchText, songbook: searchScreenArguments?.songbook),
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

    return LayoutBuilder(
      builder: (_, constraints) {
        // if (constraints.maxWidth > kTabletWidthBreakpoint) {
        //   return SplitView(
        //     left: const HomeMenu(),
        //     child: Scaffold(
        //       backgroundColor: theme.brightness.isLight ? theme.colorScheme.surface : null,
        //       body: SafeArea(child: child),
        //     ),
        //     right: constraints.maxWidth > kThreeSectionsWidthBreakpoint
        //         ? Scaffold(
        //             backgroundColor: theme.brightness.isLight ? theme.colorScheme.surface : null,
        //             body: SafeArea(child: FiltersWidget(tagsSections: songLyricsProvider.tagsSections)),
        //           )
        //         : null,
        //   );
        // }

        return Scaffold(
          backgroundColor: theme.brightness.isLight ? theme.colorScheme.surface : null,
          body: SafeArea(child: child),
        );
      },
    );
  }

  void _maybePushMatchedSonglyric(BuildContext context) {
    final songLyricsProvider = context.read<AllSongLyricsProvider>();

    if (songLyricsProvider.matchedById != null) {
      songLyricsProvider.addRecentSongLyric(songLyricsProvider.matchedById!);

      NavigationProvider.navigatorOf(context)
          .pushNamed('/song_lyric', arguments: SongLyricScreenArguments([songLyricsProvider.matchedById!], 0));
    }
  }
}
