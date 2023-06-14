import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' hide Consumer;
import 'package:zpevnik/components/bottom_navigation_bar.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_list_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/navigation.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/routes/arguments/search.dart';
import 'package:zpevnik/utils/extensions.dart';

class SongbookScreen extends StatelessWidget {
  final Songbook songbook;

  const SongbookScreen({Key? key, required this.songbook}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isTablet = MediaQuery.of(context).isTablet;
    final backgroundColor = theme.brightness.isLight ? theme.colorScheme.surface : theme.scaffoldBackgroundColor;

    final dataProvider = context.watch<DataProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isTablet ? backgroundColor : null,
        elevation: isTablet ? 0 : null,
        leading: const CustomBackButton(),
        title: Text(songbook.name, style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
        leadingWidth: 24 + 4 * kDefaultPadding,
        titleSpacing: 0,
        actions: [
          HighlightableIconButton(
            onTap: () => NavigationProvider.of(context).pushNamed(
              '/search',
              arguments: SearchScreenArguments(
                initialTag:
                    dataProvider.tags.cast<Tag?>().firstWhere((tag) => tag?.name == songbook.name, orElse: () => null),
              ),
            ),
            padding: const EdgeInsets.all(kDefaultPadding),
            icon: const Icon(Icons.filter_alt),
          ),
        ],
      ),
      backgroundColor: isTablet ? backgroundColor : null,
      bottomNavigationBar: MediaQuery.of(context).isTablet ? null : const CustomBottomNavigationBar(),
      body: SafeArea(
        child: Consumer(
          builder: (_, ref, __) => SongLyricsListView(songLyrics: ref.watch(songsListSongLyricsProvider(songbook))),
        ),
      ),
    );
  }
}
