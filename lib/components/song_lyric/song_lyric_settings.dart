import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/selector_widget.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/settings.dart';

const double _settingsOptionsWidth = 120;

class SongLyricSettingsWidget extends ConsumerWidget {
  final SongLyric songLyric;

  const SongLyricSettingsWidget({super.key, required this.songLyric});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  Consumer(
                    builder: (_, ref, __) => SelectorWidget(
                      onSelected: ref.read(songLyricSettingsProvider(songLyric).notifier).changeAccidentals,
                      options: [
                        Text('#', style: accidentalsStyle, textAlign: TextAlign.center),
                        Text('♭', style: accidentalsStyle, textAlign: TextAlign.center)
                      ],
                      selected: ref.watch(songLyricSettingsProvider(songLyric)
                          .select((songLyricSettings) => songLyricSettings.accidentals)),
                      width: _settingsOptionsWidth,
                    ),
                  ),
                ]),
                const SizedBox(height: kDefaultPadding / 2),
                Row(children: [
                  const Expanded(child: Text('Akordy')),
                  Consumer(
                    builder: (_, ref, __) => SelectorWidget(
                      onSelected: (index) =>
                          ref.read(songLyricSettingsProvider(songLyric).notifier).changeShowChords(index == 1),
                      options: const [Icon(Icons.visibility_off, size: 20), Icon(Icons.visibility, size: 20)],
                      selected: ref.watch(songLyricSettingsProvider(songLyric)
                          .select((songLyricSettings) => songLyricSettings.showChords ? 1 : 0)),
                      width: _settingsOptionsWidth,
                    ),
                  ),
                ]),
                const SizedBox(height: kDefaultPadding / 2),
              ]),
            ),
          ),
          HighlightableTextButton(
            onTap: ref.read(songLyricSettingsProvider(songLyric).notifier).reset,
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
      child: Consumer(
        builder: (_, ref, __) => Row(children: [
          HighlightableIconButton(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
            onTap: () => ref.read(songLyricSettingsProvider(songLyric).notifier).changeTransposition(-1),
            icon: const Icon(Icons.remove),
          ),
          Expanded(
            child: Text(
              '${ref.watch(songLyricSettingsProvider(songLyric).select((songLyricSettings) => songLyricSettings.transposition))}',
              textAlign: TextAlign.center,
            ),
          ),
          HighlightableIconButton(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
            onTap: () => ref.read(songLyricSettingsProvider(songLyric).notifier).changeTransposition(1),
            icon: const Icon(Icons.add),
          ),
        ]),
      ),
    );
  }
}
