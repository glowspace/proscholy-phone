import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/filters/row.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/components/song_lyrics_list_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final songLyrics = context.watch<DataProvider>().songLyrics;
    final tags = context.watch<DataProvider>().tags.sublist(0, 1);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: kDefaultPadding),
              Text('Vyhledávání', style: theme.textTheme.titleLarge),
              const SizedBox(height: kDefaultPadding / 2),
              const SearchField(key: Key('searchfield'), isInsideSearchScreen: true),
              const SizedBox(height: kDefaultPadding),
              FiltersRow(selectedTags: tags),
              const SizedBox(height: kDefaultPadding),
              Expanded(child: SongLyricsListView(songLyrics: songLyrics)),
            ],
          ),
        ),
      ),
    );
  }
}
