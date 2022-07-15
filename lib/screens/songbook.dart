import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_list_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/routes/arguments/search.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';

class SongbookScreen extends StatelessWidget {
  final Songbook songbook;

  const SongbookScreen({Key? key, required this.songbook}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(songbook.name, style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
        actions: [
          Highlightable(
            onTap: () => Navigator.of(context).pushNamed(
              '/search',
              arguments: SearchScreenArguments(songbook: songbook),
            ),
            padding: const EdgeInsets.all(kDefaultPadding),
            child: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: ChangeNotifierProxyProvider<DataProvider, SongbookSongLyricsProvider>(
          create: (context) => SongbookSongLyricsProvider(dataProvider, songbook),
          update: (_, dataProvider, songbookSongLyricsProvider) => songbookSongLyricsProvider!..update(dataProvider),
          builder: (_, __) => const SongLyricsListView<SongbookSongLyricsProvider>(),
        ),
      ),
    );
  }

  void _maybePushMatchedSonglyric(BuildContext context) {
    final songLyricsProvider = context.read<SongbookSongLyricsProvider>();

    if (songLyricsProvider.matchedById != null) {
      Navigator.of(context)
          .pushNamed('/song_lyric', arguments: SongLyricScreenArguments([songLyricsProvider.matchedById!], 0));
    }
  }
}
