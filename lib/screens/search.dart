import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/filters/filters.dart';
import 'package:zpevnik/components/filters/filters_row.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/search/search_field.dart';
import 'package:zpevnik/components/search/search_song_lyrics_list_view.dart';
import 'package:zpevnik/components/split_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/search.dart';
import 'package:zpevnik/providers/tags.dart';
import 'package:zpevnik/routing/arguments.dart';
import 'package:zpevnik/routing/router.dart';
import 'package:zpevnik/utils/extensions.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);

    final appBar = AppBar(
      automaticallyImplyLeading: false,
      // top padding is added only if there is no padding from safe area (e.g. when phone is in landscape)
      toolbarHeight: 100 + (mediaQuery.padding.top == 0 ? kDefaultPadding : 0),
      flexibleSpace: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // top padding is added only if there is no padding from safe area (e.g. when phone is in landscape)
            if (mediaQuery.padding.top == 0) const SizedBox(height: kDefaultPadding),
            SearchField(
              key: const Key('searchfield'),
              isInsideSearchScreen: true,
              onChanged: ref.read(searchTextProvider.notifier).change,
              onSubmitted: (_) => _maybePushMatchedSonglyric(context, ref),
            ),
            const Padding(
              padding: EdgeInsets.only(left: kDefaultPadding),
              child: FiltersRow(),
            ),
          ],
        ),
      ),
    );

    if (mediaQuery.isTablet && mediaQuery.isLandscape) {
      return WillPopScope(
        onWillPop: () async {
          // this is called with delay, so the change is not visible while popping from this screen
          Future.delayed(const Duration(milliseconds: 20), ref.read(selectedTagsProvider.notifier).pop);
          return true;
        },
        child: SplitView(
          childFlex: 4,
          subChildFlex: 3,
          subChild: const Scaffold(body: SafeArea(child: FiltersWidget())),
          child: CustomScaffold(appBar: appBar, body: const SafeArea(child: SearchSongLyricsListView())),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        // this is called with delay, so the change is not visible while popping from this screen
        Future.delayed(const Duration(milliseconds: 20), ref.read(selectedTagsProvider.notifier).pop);
        return true;
      },
      child: CustomScaffold(appBar: appBar, body: const SafeArea(child: SearchSongLyricsListView())),
    );
  }

  void _maybePushMatchedSonglyric(BuildContext context, WidgetRef ref) {
    final matchedById = ref.read(
      searchedSongLyricsProvider.select((searchedSongLyricsProvider) => searchedSongLyricsProvider.matchedById),
    );

    if (matchedById != null) context.push('/song_lyric', arguments: SongLyricScreenArguments.songLyric(matchedById));
  }
}
