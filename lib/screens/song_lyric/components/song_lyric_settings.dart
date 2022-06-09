import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/components/bottom_form_sheet.dart';
import 'package:zpevnik/components/font_size_slider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/selector_widget.dart';
import 'package:zpevnik/screens/song_lyric/utils/lyrics_controller.dart';
import 'package:zpevnik/theme.dart';

const double _settingsOptionsWidth = 100;

class SongLyricSettingsWidget extends StatefulWidget {
  final LyricsController lyricsController;

  const SongLyricSettingsWidget({Key? key, required this.lyricsController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongLyricSettingsWidget();
}

class _SongLyricSettingsWidget extends State<SongLyricSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final accidentalsStyle = appTheme.bodyTextStyle?.copyWith(fontSize: 20, fontFamily: 'Hiragino Sans');

    return BottomFormSheet(
      title: 'Nastavení zobrazení',
      items: [
        if (widget.lyricsController.parser.hasChords)
          Row(children: [const Expanded(child: Text('Transpozice')), _buildTranspositionStepper(context)]),
        if (widget.lyricsController.parser.hasChords) const SizedBox(height: kDefaultPadding / 2),
        if (widget.lyricsController.parser.hasChords)
          Row(children: [
            const Expanded(child: Text('Posuvky')),
            SelectorWidget(
              onSelected: widget.lyricsController.accidentalsChanged,
              options: [
                Text('#', style: accidentalsStyle, textAlign: TextAlign.center),
                Text('♭', style: accidentalsStyle, textAlign: TextAlign.center)
              ],
              selected: widget.lyricsController.accidentals,
              width: _settingsOptionsWidth,
            ),
          ]),
        if (widget.lyricsController.parser.hasChords) const SizedBox(height: kDefaultPadding / 2),
        if (widget.lyricsController.parser.hasChords)
          Row(children: [
            const Expanded(child: Text('Akordy')),
            SelectorWidget(
              onSelected: (index) => widget.lyricsController.showChordsChanged(index == 1),
              options: [
                Icon(Icons.visibility_off, color: appTheme.iconColor),
                Icon(Icons.visibility, color: appTheme.iconColor),
              ],
              selected: widget.lyricsController.showChords ? 1 : 0,
              width: _settingsOptionsWidth,
            ),
          ]),
        if (widget.lyricsController.parser.hasChords) const SizedBox(height: kDefaultPadding / 2),
        const FontSizeSlider(),
      ],
      bottomAction: Highlightable(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding),
        child: Text('Resetovat nastavení', style: AppTheme.of(context).captionTextStyle),
        onTap: widget.lyricsController.resetSettings,
      ),
    );
  }

  Widget _buildTranspositionStepper(BuildContext context) {
    return SizedBox(
      width: _settingsOptionsWidth,
      child: Row(children: [
        Highlightable(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
          child: const Icon(Icons.remove),
          onTap: () => widget.lyricsController.changeTransposition(-1),
        ),
        Expanded(child: Text(widget.lyricsController.songLyric.transposition.toString(), textAlign: TextAlign.center)),
        Highlightable(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
          child: const Icon(Icons.add),
          onTap: () => widget.lyricsController.changeTransposition(1),
        ),
      ]),
    );
  }
}
