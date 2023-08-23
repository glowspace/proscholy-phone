import 'dart:async';

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

  @override
  void initState() {
    super.initState();

    _playlistChangesSubscription = ref
        .read(appDependenciesProvider.select((appDependencies) => appDependencies.store))
        .box<PlaylistRecord>()
        .query(PlaylistRecord_.playlist.equals(widget.playlist.id))
        .watch()
        .listen((_) => setState(() {}));
  }

  @override
  void dispose() {
    _playlistChangesSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.playlist.records.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(2 * kDefaultPadding),
        child: Center(child: Text(_noPlaylistRecordText)),
      );
    }

    return ReorderableListView.builder(
      primary: false,
      itemCount: widget.playlist.records.length,
      itemBuilder: (_, index) => Slidable(
        key: Key('${widget.playlist.records[index].id}'),
        groupTag: 'playlist_record',
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.15,
          children: [
            Consumer(
              builder: (_, ref, __) => SlidableAction(
                onPressed: (_) => ref
                    .read(playlistsProvider.notifier)
                    .removeFromPlaylist(widget.playlist, widget.playlist.records[index]),
                backgroundColor: red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                padding: EdgeInsets.zero,
              ),
            )
          ],
        ),
        child: PlaylistRecordRow(
          playlistRecord: widget.playlist.records[index],
        ),
      ),
      onReorder: (_, __) {},
    );
  }
}
