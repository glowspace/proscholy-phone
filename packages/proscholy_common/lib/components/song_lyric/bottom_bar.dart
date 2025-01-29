import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/components/song_lyric/song_lyric_settings.dart';
import 'package:proscholy_common/components/song_lyric/utils/auto_scroll.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/settings.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/presentation.dart';
import 'package:proscholy_common/providers/settings.dart';
import 'package:proscholy_common/providers/display_screen_status.dart';

const double _bottomBarHeight = 64;

class SongLyricBottomBar extends ConsumerWidget {
  final SongLyric? songLyric;
  final AutoScrollController autoScrollController;

  const SongLyricBottomBar({super.key, this.songLyric, required this.autoScrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoScrollSpeedIndex = ref.watch(settingsProvider.select((settings) => settings.autoScrollSpeedIndex));

    return LayoutBuilder(
      builder: (_, constraints) => ListenableBuilder(
        listenable: autoScrollController,
        builder: (_, __) => BottomAppBar(
          height: _bottomBarHeight,
          padding: const EdgeInsets.fromLTRB(kDefaultPadding, kDefaultPadding / 4, kDefaultPadding, 0),
          child: Row(children: [
            HighlightableWidget(
              padding: const EdgeInsets.all(kDefaultPadding),
              isEnabled: songLyric?.hasChordsReal ?? false,
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (context) => SongLyricSettingsModelWidget(songLyric: songLyric!),
              ),
              icon: const Icon(Icons.tune),
              child: constraints.maxWidth > kTabletSizeBreakpoint ? const Text('Nástroje') : null,
            ),
            HighlightableWidget(
              padding: const EdgeInsets.all(kDefaultPadding),
              isEnabled: songLyric?.hasRecordings ?? false,
              onTap: ref.read(displayScreenStatusProvider.notifier).showExternals,
              icon: const Icon(FontAwesomeIcons.headphones),
              child: constraints.maxWidth > kTabletSizeBreakpoint ? const Text('Nahrávky') : null,
            ),
            HighlightableWidget(
              padding: const EdgeInsets.all(kDefaultPadding),
              onTap: ref.read(displayScreenStatusProvider.notifier).enableFullScreen,
              icon: const Icon(Icons.fullscreen),
              child: constraints.maxWidth > kTabletSizeBreakpoint ? const Text('Celá obrazovka') : null,
            ),
            const Spacer(),
            if (autoScrollController.isScrolling)
              HighlightableWidget(
                padding: const EdgeInsets.all(kDefaultPadding),
                isEnabled: autoScrollSpeedIndex != 0,
                onTap: ref.read(settingsProvider.notifier).decreaseAutoScrollSpeedIndex,
                icon: const Icon(Icons.remove),
              ),
            if (autoScrollController.isScrolling)
              HighlightableWidget(
                padding: const EdgeInsets.all(kDefaultPadding),
                isEnabled: autoScrollSpeedIndex != autoScrollSpeeds.length - 1,
                onTap: ref.read(settingsProvider.notifier).increaseAutoScrollSpeedIndex,
                icon: const Icon(Icons.add),
              ),
            HighlightableWidget(
              padding: const EdgeInsets.all(kDefaultPadding),
              isEnabled: autoScrollController.canScroll &&
                  ref.watch(presentationProvider.select((presentation) => !presentation.isPresentingLocally)),
              onTap: () => autoScrollController.toggle(ref),
              icon: autoScrollController.isScrolling ? const Icon(Icons.stop) : const Icon(Icons.arrow_downward),
              child: constraints.maxWidth > kTabletSizeBreakpoint
                  ? (autoScrollController.isScrolling ? const Text('Zastavit') : const Text('Rolovat'))
                  : null,
            ),
          ]),
        ),
      ),
    );
  }
}
