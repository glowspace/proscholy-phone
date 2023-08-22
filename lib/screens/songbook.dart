import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_list_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/song_lyrics.dart';

class SongbookScreen extends ConsumerWidget {
  final Songbook songbook;

  const SongbookScreen({super.key, required this.songbook});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(songbook.name),
        leadingWidth: 24 + 4 * kDefaultPadding,
        actions: [
          Highlightable(
            onTap: () => context.push('/search', extra: songbook),
            padding: const EdgeInsets.all(kDefaultPadding),
            icon: const Icon(Icons.filter_alt),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer(
          builder: (_, ref, __) => SongLyricsListView(songLyrics: ref.watch(songsListSongLyricsProvider(songbook))),
        ),
      ),
    );
  }
}
