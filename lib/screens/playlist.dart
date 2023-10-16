import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/playlist/playlist_button.dart';
import 'package:zpevnik/components/playlist/playlist_records_list_view.dart';
import 'package:zpevnik/components/playlist/selected_playlist_record.dart';
import 'package:zpevnik/components/split_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/playlist_record.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/menu_collapsed.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/providers/recent_items.dart';
import 'package:zpevnik/providers/tags.dart';
import 'package:zpevnik/routing/arguments.dart';
import 'package:zpevnik/routing/router.dart';
import 'package:zpevnik/screens/playlist/bible_verse.dart';
import 'package:zpevnik/screens/song_lyric.dart';
import 'package:zpevnik/utils/extensions.dart';

class PlaylistScreen extends ConsumerStatefulWidget {
  final Playlist playlist;

  const PlaylistScreen({super.key, required this.playlist});

  @override
  ConsumerState<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends ConsumerState<PlaylistScreen> {
  @override
  void initState() {
    super.initState();

    // TODO: find better place to do this, for example some observer
    Future.delayed(const Duration(milliseconds: 20), () => ref.read(recentItemsProvider.notifier).add(widget.playlist));
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).isTablet && context.isPlaylist) {
      return _PlaylistScaffoldTablet(playlist: widget.playlist);
    }

    return _PlaylistScaffold(playlist: widget.playlist);
  }
}

class _PlaylistScaffoldTablet extends ConsumerStatefulWidget {
  final Playlist playlist;

  const _PlaylistScaffoldTablet({required this.playlist});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaylistScaffoldTabletState();
}

class _PlaylistScaffoldTabletState extends ConsumerState<_PlaylistScaffoldTablet> {
  late ValueNotifier<PlaylistRecord?> _selectedPlaylistRecordNotifier;

  @override
  void initState() {
    super.initState();

    _selectedPlaylistRecordNotifier = ValueNotifier(widget.playlist.records.firstOrNull);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selectedPlaylistRecordNotifier,
      builder: (_, selectedPlaylistRecord, child) {
        if (ref.watch(menuCollapsedProvider)) return _PlaylistScaffold(playlist: widget.playlist);

        final Widget detailScreen;
        if (selectedPlaylistRecord == null) {
          detailScreen = const Placeholder();
        } else if (selectedPlaylistRecord.songLyric.target != null) {
          detailScreen = SongLyricScreen(songLyrics: [selectedPlaylistRecord.songLyric.target!]);
        } else if (selectedPlaylistRecord.bibleVerse.target != null) {
          detailScreen = BibleVerseScreen(bibleVerse: selectedPlaylistRecord.bibleVerse.target!);
        } else {
          throw UnimplementedError();
          // detailScreen = CustomTextScreen(customText: selectedPlaylistRecord.customText.target!);
        }

        return SplitView(
          childFlex: 3,
          subChildFlex: 7,
          subChild: detailScreen,
          child: child!,
        );
      },
      child: SelectedPlaylistRecord(
        playlistRecordNotifier: _selectedPlaylistRecordNotifier,
        child: _PlaylistScaffold(playlist: widget.playlist, showBackButton: false),
      ),
    );
  }
}

class _PlaylistScaffold extends ConsumerWidget {
  final Playlist playlist;
  final bool showBackButton;

  const _PlaylistScaffold({required this.playlist, this.showBackButton = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final Widget floatingActionButton;

    // only song lyrics are supported now, as it would not be possible to share other record types

    // if (playlist.isFavorites) {
    floatingActionButton = FloatingActionButton(
      heroTag: 'playlist',
      backgroundColor: theme.colorScheme.surface,
      child: const Icon(Icons.playlist_add),
      onPressed: () => _addSongLyric(context, ref),
    );
    // } else {
    //   floatingActionButton = SpeedDial(
    //     heroTag: 'playlist',
    //     icon: Icons.playlist_add,
    //     backgroundColor: theme.colorScheme.surface,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultRadius)),
    //     overlayOpacity: 0.0, // overlay will be invisible, but will allow closing the dial by tapping anywhere on screen
    //     children: [
    //       PlaylistActionButton(
    //         label: 'vlastní text',
    //         icon: Icons.edit_note,
    //         onTap: () => _addText(context, ref),
    //       ),
    //       PlaylistActionButton(
    //         label: 'biblický úryvek',
    //         icon: Icons.book_outlined,
    //         onTap: () => _addBibleVerse(context, ref),
    //       ),
    //       PlaylistActionButton(
    //         label: 'píseň',
    //         icon: Icons.music_note,
    //         onTap: () => _addSongLyric(context, ref),
    //       ),
    //     ],
    //   );
    // }

    return CustomScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackButton ? const CustomBackButton() : null,
        titleSpacing: showBackButton ? null : 2 * kDefaultPadding,
        title: Text(playlist.name),
        actions: [
          Highlightable(
            onTap: playlist.records.isEmpty ? null : () => _pushSearch(context, ref),
            padding: EdgeInsets.symmetric(horizontal: (playlist.isFavorites ? 1.5 : 1) * kDefaultPadding),
            icon: const Icon(Icons.filter_alt),
          ),
          if (!playlist.isFavorites) PlaylistButton(playlist: playlist, isInAppBar: true),
        ],
      ),
      floatingActionButton: floatingActionButton,
      hideNavigationRail: context.isPlaylists,
      body: SafeArea(child: PlaylistRecordsListView(playlist: playlist)),
    );
  }

  void _pushSearch(BuildContext context, WidgetRef ref) {
    ref.read(selectedTagsProvider.notifier).push(initialTag: playlist.tag);

    context.push('/search');
  }

  // void _addText(BuildContext context, WidgetRef ref) async {
  //   final customTextRecord = await context.push<({String name, String content})>('/playlist/custom_text');

  //   if (customTextRecord != null) ref.read(playlistsProvider.notifier).createCustomText(playlist, customTextRecord);
  // }

  // void _addBibleVerse(BuildContext context, WidgetRef ref) async {
  //   final bibleVerseRecord = (await context.push('/playlist/bible_verse')) as ({
  //     int book,
  //     int chapter,
  //     int startVerse,
  //     int? endVerse,
  //     String text
  //   })?;

  //   if (bibleVerseRecord != null) {
  //     ref.read(playlistsProvider.notifier).createBibleVerse(playlist, bibleVerseRecord);
  //   }
  // }

  void _addSongLyric(BuildContext context, WidgetRef ref) async {
    final songLyric = (await context.push('/search', arguments: SearchScreenArguments.returnSongLyric())) as SongLyric?;

    if (songLyric != null) ref.read(playlistsProvider.notifier).addToPlaylist(playlist, songLyric: songLyric);
  }
}
