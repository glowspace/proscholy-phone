import 'package:flutter/material.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/screens/song_lyric_screen.dart';

class SongLyricRow extends StatelessWidget {
  final SongLyric songLyric;

  const SongLyricRow({Key key, this.songLyric}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SongLyricScreen(songLyric: songLyric),
          ),
        ),
        child: Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child:
                    Text(songLyric.name, style: TextStyle(color: Colors.white)),
              ),
              Text(songLyric.id.toString(),
                  style: TextStyle(color: Colors.white))
            ],
          ),
        ),
      );
}
