import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_settings.dart';
import 'package:zpevnik/components/song_lyric/utils/auto_scroll.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/settings.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/full_screen.dart';
import 'package:zpevnik/providers/settings.dart';

class SongLyricBottomBar extends ConsumerWidget {
  final SongLyric songLyric;
  final AutoScrollController autoScrollController;

  const SongLyricBottomBar({super.key, required this.songLyric, required this.autoScrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoScrollSpeedIndex = ref.watch(settingsProvider.select((settings) => settings.autoScrollSpeedIndex));

    return ListenableBuilder(
      listenable: autoScrollController,
      builder: (_, __) => BottomAppBar(
        height: 44,
        padding: const EdgeInsets.fromLTRB(kDefaultPadding, kDefaultPadding / 4, kDefaultPadding, kDefaultPadding),
        child: Row(children: [
          HighlightableIconButton(
            padding: const EdgeInsets.all(kDefaultPadding),
            onTap: songLyric.hasChords ? () => _showSettings(context) : null,
            icon: const Icon(Icons.tune),
          ),
          HighlightableIconButton(
            padding: const EdgeInsets.all(kDefaultPadding),
            // onTap: _songLyric.hasRecordings ? () => _showingExternals.value = true : null,
            icon: const Icon(FontAwesomeIcons.headphones),
          ),
          HighlightableIconButton(
            padding: const EdgeInsets.all(kDefaultPadding),
            onTap: ref.read(fullScreenProvider.notifier).toggle,
            icon: const Icon(Icons.fullscreen),
          ),
          const Spacer(),
          if (autoScrollController.isScrolling)
            HighlightableIconButton(
              padding: const EdgeInsets.all(kDefaultPadding),
              onTap: autoScrollSpeedIndex == 0
                  ? null
                  : () => ref.read(settingsProvider.notifier).changeAutoScrollSpeedIndex(-1),
              icon: const Icon(Icons.remove),
            ),
          if (autoScrollController.isScrolling)
            HighlightableIconButton(
              padding: const EdgeInsets.all(kDefaultPadding),
              onTap: autoScrollSpeedIndex == autoScrollSpeeds.length - 1
                  ? null
                  : () => ref.read(settingsProvider.notifier).changeAutoScrollSpeedIndex(1),
              icon: const Icon(Icons.add),
            ),
          HighlightableIconButton(
            padding: const EdgeInsets.all(kDefaultPadding),
            onTap: autoScrollController.canScroll ? () => autoScrollController.toggle(ref) : null,
            icon: autoScrollController.isScrolling ? const Icon(Icons.stop) : const Icon(Icons.arrow_downward),
          ),
        ]),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultRadius))),
      builder: (context) => SongLyricSettingsWidget(songLyric: songLyric),
    );
  }
}
