import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:zpevnik/components/playlist/playlist_record_row.dart';
import 'package:zpevnik/components/selected_displayable_item_index.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/playlist_record.dart';
import 'package:zpevnik/providers/app_dependencies.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/routing/arguments.dart';
import 'package:zpevnik/utils/extensions.dart';

const _noPlaylistRecordText = 'V tomto seznamu nemáte žádné písně. Klikněte na tlačítko níže pro přidání nové písně.';

class PlaylistRecordsListView extends StatefulWidget {
  final Playlist playlist;

  const PlaylistRecordsListView({super.key, required this.playlist});

  @override
  State<PlaylistRecordsListView> createState() => _PlaylistRecordsListViewState();
}

class _PlaylistRecordsListViewState extends State<PlaylistRecordsListView> {
  late StreamSubscription<Query<PlaylistRecord>> _playlistChangesSubscription;

  // it is not possible to sort relations yet, so sort it here when displaying
  late List<PlaylistRecord> _recordsOrdered = widget.playlist.records.sorted((a, b) => a.rank.compareTo(b.rank));

  @override
  void initState() {
    super.initState();

    // subscribe to changes, so this widget redraws when removing record from playlist
    _playlistChangesSubscription = context.providers
        .read(appDependenciesProvider.select((appDependencies) => appDependencies.store))
        .box<PlaylistRecord>()
        .query(PlaylistRecord_.playlist.equals(widget.playlist.id))
        .watch()
        .listen((_) =>
            setState(() => _recordsOrdered = widget.playlist.records.sorted((a, b) => a.rank.compareTo(b.rank))));
  }

  @override
  void dispose() {
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

    return ReorderableListView.builder(
      primary: false,
      itemCount: _recordsOrdered.length,
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
            items: _recordsOrdered.map(_unwrapPlaylistRecord).toList(),
            initialIndex: index,
            playlist: widget.playlist,
          ),
        ),
      ),
      onReorder: _reorder,
    );
  }

  DisplayableItem _unwrapPlaylistRecord(PlaylistRecord playlistRecord) {
    if (playlistRecord.bibleVerse.targetId != 0) {
      return playlistRecord.bibleVerse.target!;
    } else if (playlistRecord.customText.targetId != 0) {
      return playlistRecord.customText.target!;
    }

    return playlistRecord.songLyric.target!;
  }

  void _reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;

    _recordsOrdered.insert(newIndex, _recordsOrdered.removeAt(oldIndex));

    widget.playlist.records.setAll(0, _recordsOrdered.mapIndexed((index, record) => record.copyWith(rank: index)));

    // `widget.playlist.records.applyToDb` saves sometimes incorrectly new ranks, so save it using `putMany`
    context.providers
        .read(appDependenciesProvider.select((appDependencies) => appDependencies.store))
        .box<PlaylistRecord>()
        .putMany(widget.playlist.records);
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
}
