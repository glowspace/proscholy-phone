import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/bottom_sheet_section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/selector_widget.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/settings.dart';

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
        SelectorWidget(
          title: 'Posuvky',
          onSelected: ref.read(songLyricSettingsProvider(songLyric).notifier).changeAccidentals,
          segments: [
            ButtonSegment(value: 0, label: Text('#', style: accidentalsStyle, textAlign: TextAlign.center)),
            ButtonSegment(value: 1, label: Text('♭', style: accidentalsStyle, textAlign: TextAlign.center)),
          ],
          selected: ref
              .watch(songLyricSettingsProvider(songLyric).select((songLyricSettings) => songLyricSettings.accidentals)),
        ),
        const SizedBox(height: kDefaultPadding / 2),
        SwitchListTile.adaptive(
          title: Text('Akordy', style: theme.textTheme.bodyMedium),
          value: ref
              .watch(songLyricSettingsProvider(songLyric).select((songLyricSettings) => songLyricSettings.showChords)),
          onChanged: (value) => ref.read(songLyricSettingsProvider(songLyric).notifier).changeShowChords(value),
          contentPadding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        ),
        if (songLyric.hasLilypond)
          SwitchListTile.adaptive(
            title: Text('Zobrazit noty', style: theme.textTheme.bodyMedium),
            activeColor: theme.colorScheme.primary,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            value: ref.watch(
                songLyricSettingsProvider(songLyric).select((songLyricSettings) => songLyricSettings.showMusicalNotes)),
            onChanged: ref.read(songLyricSettingsProvider(songLyric).notifier).changeShowMusicalNotes,
          ),
        const SizedBox(height: kDefaultPadding),
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
      width: 128,
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
