import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/custom/close_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/presentation/settings.dart';
import 'package:zpevnik/components/song_lyric/utils/parser.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/presentation.dart';
import 'package:zpevnik/routing/router.dart';

const _noExternalDisplayText =
    'Nebyl detekován žádný externí displej. Bude pouze upraveno zobrazení písní na${unbreakableSpace}tomto zařízení.';

class StartPresentationScreen extends ConsumerStatefulWidget {
  final SongLyric songLyric;

  const StartPresentationScreen({super.key, required this.songLyric});

  @override
  ConsumerState<StartPresentationScreen> createState() => _StartPresentationScreenState();
}

class _StartPresentationScreenState extends ConsumerState<StartPresentationScreen> with WidgetsBindingObserver {
  bool _onExternalDisplay = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref
        .read(presentationProvider)
        .onExternalDisplay
        .then((onExternalDisplay) => setState(() => _onExternalDisplay = onExternalDisplay));
  }

  @override
  void initState() {
    super.initState();

    ref
        .read(presentationProvider)
        .onExternalDisplay
        .then((onExternalDisplay) => setState(() => _onExternalDisplay = onExternalDisplay));

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final infoColorScheme = ColorScheme.fromSeed(seedColor: blue, brightness: Theme.of(context).brightness);

    return Scaffold(
      appBar: AppBar(
        leading: const CustomCloseButton(),
        title: const Text('Prezentovat'),
        actions: [
          Highlightable(
            onTap: () {
              ref.read(presentationProvider).start(SongLyricsParser(widget.songLyric));
              context.pop();
            },
            padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          if (!_onExternalDisplay)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: infoColorScheme.primary),
                color: infoColorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(kDefaultRadius),
              ),
              margin: const EdgeInsets.fromLTRB(kDefaultPadding, kDefaultPadding, kDefaultPadding, 0),
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Row(children: [
                Icon(Icons.info, color: infoColorScheme.onPrimaryContainer),
                const SizedBox(width: kDefaultPadding),
                const Expanded(child: Text(_noExternalDisplayText)),
              ]),
            ),
          PresentationSettingsWidget(onExternalDisplay: _onExternalDisplay),
        ]),
      ),
    );
  }
}
