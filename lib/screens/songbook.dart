import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_list_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/providers/tags.dart';
import 'package:zpevnik/routing/router.dart';

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
            onTap: () => _pushSearch(context, ref),
            padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
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

  void _pushSearch(BuildContext context, WidgetRef ref) {
    ref.read(selectedTagsProvider.notifier).push(initialTag: songbook.tag);
    context.push('/search');
  }
}
