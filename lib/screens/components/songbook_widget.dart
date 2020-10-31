import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/screens/songbook_screen.dart';

const String _songbooksPath = 'assets/images/songbooks';

const List<String> _existingLogos = ['csach', 'csatr', 'csmom', 'csmta', 'csmzd', 'sdmkr'];

class SongbookWidget extends StatelessWidget {
  final Songbook songbook;

  const SongbookWidget({Key key, this.songbook}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _pushSongbook(context),
        child: Container(
          padding: EdgeInsets.all(kDefaultPadding / 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _image(context),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      songbook.name,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );

  Widget _image(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(_existingLogos.contains(songbook.shortcut.toLowerCase())
            ? '$_songbooksPath/${songbook.shortcut.toLowerCase()}.png'
            : '$_songbooksPath/default.png'),
      );

  void _pushSongbook(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SongbookScreen(songbook: songbook),
        ),
      );
}
