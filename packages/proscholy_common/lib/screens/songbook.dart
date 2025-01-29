import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proscholy_common/components/custom/back_button.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/components/navigation/scaffold.dart';
import 'package:proscholy_common/components/song_lyric/song_lyrics_list_view.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/songbook.dart';
import 'package:proscholy_common/providers/song_lyrics.dart';
import 'package:proscholy_common/providers/tags.dart';
import 'package:proscholy_common/utils/extensions.dart';

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
          HighlightableWidget(
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
