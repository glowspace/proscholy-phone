import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:zpevnik/components/playlist/playlist_record_row.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/playlist_record.dart';
import 'package:zpevnik/providers/app_dependencies.dart';
import 'package:zpevnik/providers/playlists.dart';

const _noPlaylistRecordText = 'V tomto seznamu nemáte žádné písně. Klikněte na tlačítko níže pro přidání nové písně.';

class PlaylistRecordsListView extends ConsumerStatefulWidget {
  final Playlist playlist;

  const PlaylistRecordsListView({super.key, required this.playlist});

  @override
  ConsumerState<PlaylistRecordsListView> createState() => _PlaylistRecordsListViewState();
}

class _PlaylistRecordsListViewState extends ConsumerState<PlaylistRecordsListView> {
  late StreamSubscription<Query<PlaylistRecord>> _playlistChangesSubscription;

  // it is not possible to sort relations yet, so sort it here when displaying
  late List<PlaylistRecord> _recordsOrdered = widget.playlist.records.sorted((a, b) => a.rank.compareTo(b.rank));

  @override
  void initState() {
    super.initState();

    // subscribe to changes, so this widget redraws when removing record from playlist
    _playlistChangesSubscription = ref
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
      padding: const EdgeInsets.only(top: kDefaultPadding / 2),
      itemCount: _recordsOrdered.length,
      itemBuilder: (_, index) => Slidable(
        key: Key('${_recordsOrdered[index].id}'),
        groupTag: 'playlist_record',
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.15,
          children: [
            Consumer(
              builder: (_, ref, __) => SlidableAction(
                onPressed: (_) =>
                    ref.read(playlistsProvider.notifier).removeFromPlaylist(widget.playlist, _recordsOrdered[index]),
                backgroundColor: red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                padding: EdgeInsets.zero,
              ),
            )
          ],
        ),
        child: PlaylistRecordRow(playlistRecord: _recordsOrdered[index]),
      ),
      onReorder: _reorder,
    );
  }

  void _reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;

    _recordsOrdered.insert(newIndex, _recordsOrdered.removeAt(oldIndex));

    widget.playlist.records.setAll(0, _recordsOrdered.mapIndexed((index, record) => record.copyWith(rank: index)));

    // `widget.playlist.records.applyToDb` saves sometimes incorrectly new ranks, so save it using `putMany`
    ref
        .read(appDependenciesProvider.select((appDependencies) => appDependencies.store))
        .box<PlaylistRecord>()
        .putMany(widget.playlist.records);
  }
}
