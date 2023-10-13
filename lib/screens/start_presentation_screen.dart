import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/presentation/settings.dart';
import 'package:zpevnik/components/song_lyric/utils/parser.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/presentation.dart';
import 'package:zpevnik/routing/router.dart';

const _noExternalDisplayText =
    'Není připojen žádný externí displej. Aplikace v současné době nepodporuje žádné způsoby připojení a je proto nutné, abyste se k externímu displeji připojili pomocí jiné aplikace (např. airplay, chromecast). Poté bude promítání povoleno.';

class StartPresentationScreen extends ConsumerStatefulWidget {
  final SongLyric songLyric;

  const StartPresentationScreen({super.key, required this.songLyric});

  @override
  ConsumerState<StartPresentationScreen> createState() => _StartPresentationScreenState();
}

class _StartPresentationScreenState extends ConsumerState<StartPresentationScreen> with WidgetsBindingObserver {
  bool _canPresent = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref.read(presentationProvider).canPresent.then((canPresent) => setState(() => _canPresent = canPresent));
  }

  @override
  void initState() {
    super.initState();

    ref.read(presentationProvider).canPresent.then((canPresent) => setState(() => _canPresent = canPresent));

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

    return CustomScaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: const Text('Prezentovat'),
        leadingWidth: 24 + 4 * kDefaultPadding,
        actions: [
          Highlightable(
            onTap: () {
              ref.read(presentationProvider).start(SongLyricsParser(widget.songLyric));
              context.pop();
            },
            // isEnabled: _canPresent,
            padding: const EdgeInsets.all(kDefaultPadding),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          if (!_canPresent)
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
          const PresentationSettingsWidget(),
        ]),
      ),
    );
  }
}
