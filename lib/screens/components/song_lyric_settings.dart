import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/screens/components/highlithtable_button.dart';
import 'package:zpevnik/screens/components/selector_widget.dart';
import 'package:zpevnik/theme.dart';

class SongLyricSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<SongLyric>(
        builder: (context, songLyric, _) => Container(
          padding: EdgeInsets.all(kDefaultPadding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: kDefaultPadding / 2),
                  child: Text('Nastavení zobrazení', style: Theme.of(context).textTheme.headline6),
                ),
                _row(
                  'Transpozice',
                  _transitionStepper(),
                ),
                _row(
                  'Posuvky',
                  SelectorWidget(
                    onSelected: (index) => songLyric.accidentals = index == 1,
                    options: [
                      Text(
                        '#',
                        style:
                            Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20, fontFamily: 'Hiragino Sans'),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '♭',
                        style:
                            Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20, fontFamily: 'Hiragino Sans'),
                        textAlign: TextAlign.center,
                      )
                    ],
                    selected: songLyric.accidentals ? 1 : 0,
                  ),
                ),
                _row(
                  'Akordy',
                  SelectorWidget(
                    onSelected: (index) => songLyric.showChords = index == 1,
                    options: [
                      Icon(Icons.visibility_off),
                      Icon(Icons.visibility),
                    ],
                    selected: songLyric.showChords ? 1 : 0,
                  ),
                ),
                _fontSizeSlider(context),
              ],
            ),
          ),
        ),
      );

  Widget _row(String name, Widget widget) => Container(
        padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name),
            widget,
          ],
        ),
      );

  Widget _transitionStepper() => Container(
        child: Consumer<SongLyric>(
          builder: (context, songLyric, _) => Row(
            children: [
              HighlightableButton(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
                icon: Icons.remove,
                highlightedColor: AppTheme.shared.highlightColor(context),
                onPressed: () => songLyric.changeTransposition(-1),
              ),
              SizedBox(
                width: 22,
                child: Text(
                  songLyric.transposition.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              HighlightableButton(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
                icon: Icons.add,
                highlightedColor: AppTheme.shared.highlightColor(context),
                onPressed: () => songLyric.changeTransposition(1),
              ),
            ],
          ),
        ),
      );

  Widget _fontSizeSlider(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 3),
        child: Consumer<SongLyric>(
          builder: (context, songLyric, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Velikost písma'),
              Row(
                children: [
                  Text('A', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: kMinimumFontSize)),
                  Flexible(
                    child: Slider(
                      value: songLyric.fontSize,
                      onChanged: songLyric.changeFontSize,
                      min: kMinimumFontSize,
                      max: kMaximumFontSize,
                    ),
                  ),
                  Text('A', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: kMaximumFontSize)),
                ],
              )
            ],
          ),
        ),
      );
}
