import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/playlist/action_button.dart';
import 'package:zpevnik/components/playlist/playlist_button.dart';
import 'package:zpevnik/components/playlist/playlist_records_list_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/playlists.dart';

class PlaylistScreen extends ConsumerWidget {
  final Playlist playlist;

  const PlaylistScreen({super.key, required this.playlist});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final Widget floatingActionButton;

    if (playlist.isFavorites) {
      floatingActionButton = FloatingActionButton(
        backgroundColor: theme.canvasColor,
        child: const Icon(Icons.playlist_add),
        onPressed: () => _addSongLyric(context, ref),
      );
    } else {
      floatingActionButton = SpeedDial(
        icon: Icons.playlist_add,
        backgroundColor: theme.canvasColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultRadius)),
        overlayOpacity: 0.0, // overlay will be invisible, but will allow closing the dial by tapping anywhere on screen
        children: [
          PlaylistActionButton(
            label: 'vlastní text',
            icon: Icons.edit_note,
            onTap: () => _addText(context, ref),
          ),
          PlaylistActionButton(
            label: 'biblický úryvek',
            icon: Icons.book_outlined,
            onTap: () => _addBibleVerse(context, ref),
          ),
          PlaylistActionButton(
            label: 'píseň',
            icon: Icons.music_note,
            onTap: () => _addSongLyric(context, ref),
          ),
        ],
      );
    }

    return CustomScaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(playlist.name),
        actions: [
          Highlightable(
            onTap: playlist.records.isEmpty ? null : () => context.push('/search'), // TODO: use arguments
            padding: const EdgeInsets.all(kDefaultPadding),
            icon: const Icon(Icons.filter_alt),
          ),
          if (!playlist.isFavorites) PlaylistButton(playlist: playlist, isInAppBar: true, extendPadding: true),
        ],
      ),
      floatingActionButton: playlist.records.isEmpty ? null : floatingActionButton,
      body: SafeArea(child: PlaylistRecordsListView(playlist: playlist)),
    );
  }

  void _addText(BuildContext context, WidgetRef ref) async {
    final customTextRecord = await context.push<({String name, String content})>('/playlist/custom_text');

    if (customTextRecord != null) ref.read(playlistsProvider.notifier).createCustomText(playlist, customTextRecord);
  }

  void _addBibleVerse(BuildContext context, WidgetRef ref) async {
    final bibleVerseRecord = await context
        .push<({int book, int chapter, int startVerse, int? endVerse, String text})>('/playlist/bible_verse');

    if (bibleVerseRecord != null) {
      ref.read(playlistsProvider.notifier).createBibleVerse(playlist, bibleVerseRecord);
    }
  }

  void _addSongLyric(BuildContext context, WidgetRef ref) async {
    // TODO: use arguments
    final songLyric = await context.push<SongLyric>('/search');

    if (songLyric != null) ref.read(playlistsProvider.notifier).addToPlaylist(playlist, songLyric: songLyric);
  }
}
