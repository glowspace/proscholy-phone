import 'package:flutter/material.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/screens/songbook_screen.dart';

const String _songbooksPath = 'assets/images/songbooks';

const List<String> _existingLogos = [
  'csach',
  'csatr',
  'csmom',
  'csmta',
  'csmzd',
  'sdmkr'
];

class SongbookWidget extends StatelessWidget {
  final Songbook songbook;

  const SongbookWidget({Key key, this.songbook}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SongbookScreen(songbook: songbook),
          ),
        ),
        child: Column(
          children: [
            _image(context),
            Text(
              songbook.name,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      );

  Widget _image(BuildContext context) =>
      Image.asset(_existingLogos.contains(songbook.shortcut.toLowerCase())
          ? '$_songbooksPath/${songbook.shortcut.toLowerCase()}.png'
          : '$_songbooksPath/default.png');
}
