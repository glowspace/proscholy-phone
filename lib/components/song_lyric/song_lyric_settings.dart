import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/components/bottom_form_sheet.dart';
import 'package:zpevnik/components/font_size_slider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/selector_widget.dart';
import 'package:zpevnik/screens/song_lyric/utils/lyrics_controller.dart';

const double _settingsOptionsWidth = 100;

class SongLyricSettingsWidget extends StatefulWidget {
  final LyricsController controller;

  const SongLyricSettingsWidget({Key? key, required this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongLyricSettingsWidget();
}

class _SongLyricSettingsWidget extends State<SongLyricSettingsWidget> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_update);
  }

  @override
  void dispose() {
    super.dispose();

    widget.controller.removeListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accidentalsStyle = theme.textTheme.bodyMedium?.copyWith(fontSize: 20, fontFamily: 'Hiragino Sans');

    final hasChords = widget.controller.songLyric.hasChords;

    return BottomFormSheet(
      title: 'Nastavení zobrazení',
      items: [
        if (hasChords) Row(children: [const Expanded(child: Text('Transpozice')), _buildTranspositionStepper(context)]),
        if (hasChords) const SizedBox(height: kDefaultPadding / 2),
        if (hasChords)
          Row(children: [
            const Expanded(child: Text('Posuvky')),
            SelectorWidget(
              onSelected: widget.controller.accidentalsChanged,
              options: [
                Text('#', style: accidentalsStyle, textAlign: TextAlign.center),
                Text('♭', style: accidentalsStyle, textAlign: TextAlign.center)
              ],
              selected: widget.controller.accidentals,
              width: _settingsOptionsWidth,
            ),
          ]),
        if (hasChords) const SizedBox(height: kDefaultPadding / 2),
        if (hasChords)
          Row(children: [
            const Expanded(child: Text('Akordy')),
            SelectorWidget(
              onSelected: (index) => widget.controller.showChordsChanged(index == 1),
              options: const [Icon(Icons.visibility_off), Icon(Icons.visibility)],
              selected: widget.controller.showChords ? 1 : 0,
              width: _settingsOptionsWidth,
            ),
          ]),
        if (hasChords) const SizedBox(height: kDefaultPadding / 2),
        const FontSizeSlider(),
      ],
      bottomAction: Highlightable(
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Text('Resetovat nastavení', style: theme.textTheme.caption),
        ),
        onTap: widget.controller.resetSettings,
      ),
    );
  }

  Widget _buildTranspositionStepper(BuildContext context) {
    return SizedBox(
      width: _settingsOptionsWidth,
      child: Row(children: [
        Highlightable(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
            child: const Icon(Icons.remove),
          ),
          onTap: () => widget.controller.changeTransposition(-1),
        ),
        Expanded(child: Text('${widget.controller.songLyric.transposition}', textAlign: TextAlign.center)),
        Highlightable(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
            child: const Icon(Icons.add),
          ),
          onTap: () => widget.controller.changeTransposition(1),
        ),
      ]),
    );
  }

  void _update() => setState(() {});
}
