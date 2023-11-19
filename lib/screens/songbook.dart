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
import 'package:zpevnik/utils/extensions.dart';

class SongbookScreen extends StatelessWidget {
  final Songbook songbook;

  const SongbookScreen({super.key, required this.songbook});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: context.isSongbook ? const CustomBackButton() : null,
        titleSpacing: context.isSongbook ? null : 2 * kDefaultPadding,
        title: Text(songbook.name),
        actions: [
          Highlightable(
            onTap: () => _pushSearch(context),
            padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
            icon: const Icon(Icons.filter_alt),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Consumer(
          builder: (_, ref, __) => SongLyricsListView(
            songLyrics: ref.watch(songsListSongLyricsProvider(songbook)),
            songbook: songbook,
          ),
        ),
      ),
    );
  }

  void _pushSearch(BuildContext context) {
    context.providers.read(selectedTagsProvider.notifier).push(initialTag: songbook.tag);

    context.push('/search');
  }
}
