import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';

class SongLyricRorderableRow extends StatelessWidget {
  final SongLyric songLyric;

  const SongLyricRorderableRow({Key key, this.songLyric}) : super(key: key);

  @override
  Widget build(BuildContext context) => ReorderableItem(
        key: songLyric.key,
        childBuilder: (context, state) => Container(
          child: Row(
            children: [
              ReorderableListener(
                child: Container(
                  padding: EdgeInsets.only(left: kDefaultPadding / 2),
                  child: Icon(
                    Icons.drag_handle,
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                ),
              ),
              Expanded(
                child: SongLyricRow(songLyric: songLyric, showStar: false),
              ),
            ],
          ),
        ),
      );
}
