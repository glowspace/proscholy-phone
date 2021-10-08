import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/screens/components/bottom_form_sheet.dart';
import 'package:zpevnik/screens/components/font_size_slider.dart';
import 'package:zpevnik/screens/components/highlightable.dart';
import 'package:zpevnik/screens/components/selector_widget.dart';
import 'package:zpevnik/screens/song_lyric/utils/lyrics_controller.dart';
import 'package:zpevnik/screens/utils/updateable.dart';
import 'package:zpevnik/theme.dart';

class SongLyricSettingsWidget extends StatefulWidget {
  final LyricsController songLyricController;

  const SongLyricSettingsWidget({Key? key, required this.songLyricController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongLyricSettingsWidget();
}

class _SongLyricSettingsWidget extends State<SongLyricSettingsWidget> with Updateable {
  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final accidentalsStyle = appTheme.bodyTextStyle?.copyWith(fontSize: 20, fontFamily: 'Hiragino Sans');

    final controller = widget.songLyricController;

    return BottomFormSheet(
      title: 'Nastavení zobrazení',
      items: [
        _row('Transpozice', _transpositionStepper()),
        _row(
          'Posuvky',
          SelectorWidget(
            onSelected: controller.accidentalsChanged,
            options: [
              Text('#', style: accidentalsStyle, textAlign: TextAlign.center),
              Text('♭', style: accidentalsStyle, textAlign: TextAlign.center)
            ],
            selected: controller.accidentals,
            width: 120,
          ),
        ),
        _row(
          'Akordy',
          SelectorWidget(
            onSelected: (index) => controller.showChordsChanged(index == 1),
            options: [
              Icon(Icons.visibility_off, color: appTheme.iconColor),
              Icon(Icons.visibility, color: appTheme.iconColor),
            ],
            selected: controller.showChords ? 1 : 0,
            width: 120,
          ),
        ),
        FontSizeSlider(),
      ],
      bottomAction: Highlightable(
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding),
        child: Text('Resetovat nastavení', style: AppTheme.of(context).captionTextStyle),
        onPressed: controller.resetSettings,
      ),
    );
  }

  Widget _row(String name, Widget widget) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          widget,
        ],
      ),
    );
  }

  Widget _transpositionStepper() {
    final controller = widget.songLyricController;
    final songLyric = controller.songLyric;

    return Container(
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Highlightable(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
            child: Icon(Icons.remove),
            onPressed: () => controller.changeTransposition(-1),
          ),
          SizedBox(
            width: 32,
            child: Text(songLyric.transposition.toString(), textAlign: TextAlign.center),
          ),
          Highlightable(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
            child: Icon(Icons.add),
            onPressed: () => controller.changeTransposition(1),
          ),
        ],
      ),
    );
  }

  @override
  List<Listenable> get listenables => [widget.songLyricController];
}
