import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/selector_widget.dart';
import 'package:zpevnik/components/song_lyric/utils/lyrics_controller.dart';

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

    return SafeArea(
      top: false,
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Text('Nastavení zobrazení', style: Theme.of(context).textTheme.titleLarge),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(children: [
                Row(children: [const Expanded(child: Text('Transpozice')), _buildTranspositionStepper(context)]),
                const SizedBox(height: kDefaultPadding / 2),
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
                const SizedBox(height: kDefaultPadding / 2),
                Row(children: [
                  const Expanded(child: Text('Akordy')),
                  SelectorWidget(
                    onSelected: (index) => widget.controller.showChordsChanged(index == 1),
                    options: const [Icon(Icons.visibility_off, size: 20), Icon(Icons.visibility, size: 20)],
                    selected: widget.controller.showChords ? 1 : 0,
                    width: _settingsOptionsWidth,
                  ),
                ]),
                const SizedBox(height: kDefaultPadding / 2),
              ]),
            ),
          ),
          HighlightableTextButton(
            onTap: widget.controller.resetSettings,
            padding: const EdgeInsets.all(kDefaultPadding),
            textStyle: theme.textTheme.bodySmall,
            child: const Text('Resetovat nastavení'),
          ),
        ],
      ),
    );
  }

  Widget _buildTranspositionStepper(BuildContext context) {
    return SizedBox(
      width: _settingsOptionsWidth,
      child: Row(children: [
        HighlightableIconButton(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
          onTap: () => widget.controller.changeTransposition(-1),
          icon: const Icon(Icons.remove),
        ),
        Expanded(child: Text('${widget.controller.songLyric.transposition}', textAlign: TextAlign.center)),
        HighlightableIconButton(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
          onTap: () => widget.controller.changeTransposition(1),
          icon: const Icon(Icons.add),
        ),
      ]),
    );
  }

  void _update() => setState(() {});
}
