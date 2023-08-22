import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zpevnik/components/filters/filters.dart';
import 'package:zpevnik/components/filters/filters_row.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/search/search_field.dart';
import 'package:zpevnik/components/search/search_song_lyrics_list_view.dart';
import 'package:zpevnik/components/split_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/search.dart';
import 'package:zpevnik/providers/tags.dart';
import 'package:zpevnik/utils/extensions.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final Tag? initialTag;

  const SearchScreen({super.key, this.initialTag});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.initialTag != null) {
      // FIXME: there should be better way of doing this, now it will build with all song lyrics and after frame rebuild with only given tag
      // must be done with delay, as it forces rebuild
      Future.delayed(
          const Duration(milliseconds: 20),
          () => ref
              .read(selectedTagsByTypeProvider(widget.initialTag!.type).notifier)
              .toggleSelection(widget.initialTag!));
    }
  }

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
              isInsideSearchScreen: true,
              onChanged: ref.read(searchTextProvider.notifier).change,
              onSubmitted: (_) => _maybePushMatchedSonglyric(context, ref),
            ),
            Container(
              padding: const EdgeInsets.only(left: kDefaultPadding),
              child: const FiltersRow(),
            ),
          ],
        ),
      ),
    );

    if (mediaQuery.isTablet && mediaQuery.isLandscape) {
      return SplitView(
        subChild: const Scaffold(body: SafeArea(child: FiltersWidget())),
        child: CustomScaffold(appBar: appBar, body: const SearchSongLyricsListView()),
      );
    }

    return CustomScaffold(appBar: appBar, body: const SearchSongLyricsListView());
  }

  void _maybePushMatchedSonglyric(BuildContext context, WidgetRef ref) {
    final matchedById = ref.read(
      searchedSongLyricsProvider.select((searchedSongLyricsProvider) => searchedSongLyricsProvider.matchedById),
    );

    if (matchedById != null) context.push('/song_lyric', extra: matchedById);
  }
}
