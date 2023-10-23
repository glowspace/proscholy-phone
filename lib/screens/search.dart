import 'package:flutter/material.dart';
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
import 'package:zpevnik/utils/extensions.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              onChanged: context.providers.read(searchTextProvider.notifier).change,
              onSubmitted: (_) => _maybePushMatchedSonglyric(context),
            ),
            const Padding(
              padding: EdgeInsets.only(left: kDefaultPadding),
              child: FiltersRow(),
            ),
          ],
        ),
      ),
    );

    final Widget child;

    if (mediaQuery.isTablet && mediaQuery.isLandscape && context.isSearching) {
      child = SplitView(
        childFlex: 4,
        detailFlex: 3,
        detail: const Scaffold(body: SafeArea(child: FiltersWidget())),
        child: CustomScaffold(appBar: appBar, body: const SafeArea(child: SearchSongLyricsListView())),
      );
    } else {
      child = CustomScaffold(appBar: appBar, body: const SafeArea(child: SearchSongLyricsListView()));
    }

    return WillPopScope(
      onWillPop: () async {
        // this is called with delay, so the change is not visible while popping from this screen
        Future.delayed(const Duration(milliseconds: 20), context.providers.read(selectedTagsProvider.notifier).pop);
        return true;
      },
      child: child,
    );
  }

  void _maybePushMatchedSonglyric(BuildContext context) {
    final matchedById = context.providers.read(
      searchedSongLyricsProvider.select((searchedSongLyricsProvider) => searchedSongLyricsProvider.matchedById),
    );

    if (matchedById != null) context.push('/display', arguments: DisplayScreenArguments.songLyric(matchedById));
  }
}
