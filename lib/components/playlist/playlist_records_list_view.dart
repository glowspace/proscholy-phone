import 'package:flutter/material.dart';
import 'package:zpevnik/components/playlist/playlist_record_row.dart';
import 'package:zpevnik/models/playlist.dart';

class PlaylistRecordsListView extends StatelessWidget {
  final Playlist playlist;

  const PlaylistRecordsListView({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      primary: false,
      itemCount: playlist.records.length,
      itemBuilder: (_, index) => PlaylistRecordRow(
        key: Key('${playlist.records[index].id}'),
        playlistRecord: playlist.records[index],
      ),
      onReorder: (_, __) {},
    );
  }
}
