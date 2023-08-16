import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/bottom_sheet_section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/selector_widget.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/settings.dart';

const double _settingsOptionsWidth = 128;

class SongLyricSettingsWidget extends ConsumerWidget {
  final SongLyric songLyric;

  const SongLyricSettingsWidget({super.key, required this.songLyric});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final accidentalsStyle = theme.textTheme.bodyMedium?.copyWith(fontSize: 20, fontFamily: 'Hiragino Sans');

    return BottomSheetSection(
      title: 'Nastavení zobrazení',
      children: [
        const SizedBox(height: kDefaultPadding),
        Row(children: [const Expanded(child: Text('Transpozice')), _buildTranspositionStepper(context)]),
        Row(children: [
          const Expanded(child: Text('Posuvky')),
          SelectorWidget(
            onSelected: ref.read(songLyricSettingsProvider(songLyric).notifier).changeAccidentals,
            segments: [
              ButtonSegment(value: 0, label: Text('#', style: accidentalsStyle, textAlign: TextAlign.center)),
              ButtonSegment(value: 1, label: Text('♭', style: accidentalsStyle, textAlign: TextAlign.center)),
            ],
            selected: ref.watch(
                songLyricSettingsProvider(songLyric).select((songLyricSettings) => songLyricSettings.accidentals)),
            width: _settingsOptionsWidth,
          ),
        ]),
        const SizedBox(height: kDefaultPadding / 2),
        Row(children: [
          const Expanded(child: Text('Akordy')),
          SelectorWidget(
            onSelected: (index) => ref.read(songLyricSettingsProvider(songLyric).notifier).changeShowChords(index == 1),
            segments: const [
              ButtonSegment(value: 0, icon: Icon(Icons.visibility_off, size: 20)),
              ButtonSegment(value: 1, icon: Icon(Icons.visibility, size: 20)),
            ],
            selected: ref.watch(songLyricSettingsProvider(songLyric)
                .select((songLyricSettings) => songLyricSettings.showChords ? 1 : 0)),
            width: _settingsOptionsWidth,
          ),
        ]),
        SwitchListTile.adaptive(
          title: Text('Zobrazit noty', style: theme.textTheme.bodyMedium),
          activeColor: theme.colorScheme.primary,
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          value: ref.watch(
              songLyricSettingsProvider(songLyric).select((songLyricSettings) => songLyricSettings.showMusicalNotes)),
          onChanged: ref.read(songLyricSettingsProvider(songLyric).notifier).changeShowMusicalNotes,
        ),
        const SizedBox(height: kDefaultPadding / 2),
        Highlightable(
          onTap: ref.read(songLyricSettingsProvider(songLyric).notifier).reset,
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          textStyle: theme.textTheme.bodySmall,
          child: const Text('Resetovat nastavení'),
        ),
      ],
    );
  }

  Widget _buildTranspositionStepper(BuildContext context) {
    return SizedBox(
      width: _settingsOptionsWidth,
      child: Consumer(
        builder: (_, ref, __) => Row(children: [
          Highlightable(
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
          Highlightable(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
            onTap: () => ref.read(songLyricSettingsProvider(songLyric).notifier).changeTransposition(1),
            icon: const Icon(Icons.add),
          ),
        ]),
      ),
    );
  }
}
