import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';

class SongLyricSettings extends StatelessWidget {
  final SongLyric songLyric;

  const SongLyricSettings({Key key, this.songLyric}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nastavení', style: Theme.of(context).textTheme.headline6),
            Row(
              children: [
                Text('Transpozice'),
                Spacer(),
                GestureDetector(
                  onTap: () => songLyric.changeTransposition(-1),
                  child: Icon(Icons.remove),
                ),
                Text('0'),
                GestureDetector(
                  onTap: () => songLyric.changeTransposition(1),
                  child: Icon(Icons.add),
                ),
              ],
            ),
            Row(
              children: [
                Text('Posuvky'),

                // CupertinoSlidingSegmentedControl(children: null, onValueChanged: null)
              ],
            ),
            Row(
              children: [
                Text('Akordy'),

                // CupertinoSlidingSegmentedControl(children: null, onValueChanged: null)
              ],
            ),
            Row(
              children: [
                Text('Velikost písma'),
                Slider(
                  value: 17,
                  onChanged: (value) {},
                  min: 15,
                  max: 53,
                )
              ],
            )
          ],
        ),
      );
}
