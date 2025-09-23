import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:proscholy_common/components/playlist/playlist_record_row.dart';
import 'package:proscholy_common/components/selected_displayable_item_arguments.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/model.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/playlist_record.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/bible_verse.dart';
import 'package:proscholy_common/providers/custom_text.dart';
import 'package:proscholy_common/providers/playlists.dart';
import 'package:proscholy_common/providers/song_lyrics.dart';
import 'package:proscholy_common/routing/arguments.dart';
import 'package:proscholy_common/utils/extensions.dart';

const _noPlaylistRecordText = 'V tomto seznamu nemáte žádné písně. Klikněte na tlačítko níže pro přidání nové písně.';

class PlaylistRecordsListView extends ConsumerStatefulWidget {
  final Playlist playlist;
  final ValueNotifier<bool> sortedAlphabeticallyNotifier;

  const PlaylistRecordsListView({super.key, required this.playlist, required this.sortedAlphabeticallyNotifier});

  @override
  ConsumerState<PlaylistRecordsListView> createState() => _PlaylistRecordsListViewState();
}

class _PlaylistRecordsListViewState extends ConsumerState<PlaylistRecordsListView> {
  late StreamSubscription<Query<PlaylistRecord>> _playlistChangesSubscription;

  // it is not possible to sort relations yet, so sort it here when displaying
  late List<PlaylistRecord> _recordsOrdered =
      _filterInvalidRecords(widget.playlist.records.sorted((a, b) => a.rank.compareTo(b.rank)));

  @override
  void initState() {
    super.initState();

    // subscribe to changes, so this widget redraws when removing record from playlist
    _playlistChangesSubscription = context.providers
        .read(appDependenciesProvider)
        .store
        .box<PlaylistRecord>()
        .query(PlaylistRecord_.playlist.equals(widget.playlist.id))
        .watch()
        .listen((_) {
      setState(() =>
          _recordsOrdered = _filterInvalidRecords(widget.playlist.records.sorted((a, b) => a.rank.compareTo(b.rank))));

      final selectedDisplayableItemArgumentsNotifier = SelectedDisplayableItemArguments.of(context, listen: false);

      if (selectedDisplayableItemArgumentsNotifier != null) {
        final displayableItems = _recordsOrdered.map(_unwrapPlaylistRecord).toList();

        for (int i = 0; i < displayableItems.length; i++) {
          if (displayableItems[i] ==
              selectedDisplayableItemArgumentsNotifier
                  .value.items[selectedDisplayableItemArgumentsNotifier.value.initialIndex]) {
            selectedDisplayableItemArgumentsNotifier.value = DisplayScreenArguments(
              items: displayableItems,
              initialIndex: i,
              playlist: widget.playlist,
            );

            return;
          }
        }

        selectedDisplayableItemArgumentsNotifier.value = DisplayScreenArguments(
          items: displayableItems,
          initialIndex: 0,
          playlist: widget.playlist,
        );
      }
    });

    widget.sortedAlphabeticallyNotifier.addListener(_sortedAlphabeticallyChanged);
  }

  @override
  void dispose() {
    widget.sortedAlphabeticallyNotifier.removeListener(_sortedAlphabeticallyChanged);
    _playlistChangesSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_recordsOrdered.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(2 * kDefaultPadding),
        child: Center(child: Text(_noPlaylistRecordText)),
      );
    }

    final displayableItems = _recordsOrdered.map(_unwrapPlaylistRecord).toList();

    return ReorderableListView.builder(
      primary: false,
      padding: const EdgeInsets.only(top: kDefaultPadding / 3),
      itemCount: displayableItems.length,
      itemBuilder: (_, index) => Slidable(
        key: Key('${_recordsOrdered[index].id}'),
        groupTag: 'playlist_record',
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.15,
          children: [
            SlidableAction(
              onPressed: (_) => _removePlaylistRecord(index),
              backgroundColor: red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        child: PlaylistRecordRow(
          playlistRecord: _recordsOrdered[index],
          displayScreenArguments: DisplayScreenArguments(
            items: displayableItems,
            initialIndex: index,
            playlist: widget.playlist,
          ),
        ),
      ),
      onReorder: _reorder,
    );
  }

  // TODO: temporary fix, so there are playlist records can't fail during _unwrapPlaylistRecord
  List<PlaylistRecord> _filterInvalidRecords(List<PlaylistRecord> playlistRecords) {
    return playlistRecords.where((playlistRecord) {
      final bibleVerse = ref.watch(bibleVerseProvider(playlistRecord.bibleVerse.targetId));
      final customText = ref.watch(customTextProvider(playlistRecord.customText.targetId));
      final songLyric = ref.watch(songLyricProvider(playlistRecord.songLyric.targetId));

      if (bibleVerse == null && customText == null && songLyric == null)
        Sentry.captureMessage('had to filter invalid record');

      return bibleVerse != null || customText != null || songLyric != null;
    }).toList();
  }

  DisplayableItem _unwrapPlaylistRecord(PlaylistRecord playlistRecord) {
    final bibleVerse = ref.watch(bibleVerseProvider(playlistRecord.bibleVerse.targetId));
    final customText = ref.watch(customTextProvider(playlistRecord.customText.targetId));
    final songLyric = ref.watch(songLyricProvider(playlistRecord.songLyric.targetId));

    if (bibleVerse != null) {
      return bibleVerse;
    } else if (customText != null) {
      return customText;
    }

    return songLyric!;
  }

  void _reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;

    if (oldIndex == newIndex) return;

    _recordsOrdered.insert(newIndex, _recordsOrdered.removeAt(oldIndex));

    widget.playlist.records.setAll(0, _recordsOrdered.mapIndexed((index, record) => record.copyWith(rank: index)));

    // `widget.playlist.records.applyToDb` saves sometimes incorrectly new ranks, so save it using `putMany`
    context.providers.read(appDependenciesProvider).store.box<PlaylistRecord>().putMany(widget.playlist.records);

    widget.sortedAlphabeticallyNotifier.value = false;
  }

  void _removePlaylistRecord(int index) {
    context.providers.read(playlistsProvider.notifier).removeFromPlaylist(widget.playlist, _recordsOrdered[index]);

    final removed = _recordsOrdered.removeAt(index);

    final selectedDisplayableItemArguments = SelectedDisplayableItemArguments.of(context);

    // change selected item if it was removed
    if (selectedDisplayableItemArguments != null &&
        selectedDisplayableItemArguments.value.items[selectedDisplayableItemArguments.value.initialIndex] ==
            _unwrapPlaylistRecord(removed)) {
      if (index == _recordsOrdered.length) index--;

      // if there are no more records pop out to all playlists
      if (index < 0) {
        context.pop();

        return;
      }

      selectedDisplayableItemArguments.value = DisplayScreenArguments(
        items: _recordsOrdered.map(_unwrapPlaylistRecord).toList(),
        initialIndex: index,
        playlist: widget.playlist,
      );
    }
  }

  void _sortedAlphabeticallyChanged() {
    if (widget.sortedAlphabeticallyNotifier.value) {
      setState(() => _recordsOrdered = widget.playlist.records
          .sorted((a, b) => _unwrapPlaylistRecord(a).displayName.compareTo(_unwrapPlaylistRecord(b).displayName)));
    } else {
      setState(() => _recordsOrdered = widget.playlist.records.sorted((a, b) => a.rank.compareTo(b.rank)));
    }
  }
}
