import 'package:flutter/material.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/screens/song_lyric_screen.dart';

class SongLyricRow extends StatelessWidget {
  final SongLyric songLyric;

  const SongLyricRow({Key key, this.songLyric}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _pushSongLyric(context),
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(songLyric.name, style: Theme.of(context).textTheme.bodyText1),
              ),
              Text(songLyric.id.toString(), style: Theme.of(context).textTheme.caption)
            ],
          ),
        ),
      );

  void _pushSongLyric(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SongLyricScreen(songLyric: songLyric),
        ),
      );
}
