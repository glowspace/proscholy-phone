import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/presentation/settings.dart';
import 'package:zpevnik/components/song_lyric/utils/parser.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/presentation.dart';

const _noExternalDisplayText =
    'Není připojen žádný externí displej. Aplikace v současné době nepodporuje žádné způsoby připojení a je proto nutné, abyste se k externímu displeji připojili pomocí jiné aplikace (např. airplay, chromecast). Poté bude promítání povoleno.';

class StartPresentationScreen extends StatefulWidget {
  final SongLyricsParser songLyricsParser;

  const StartPresentationScreen({super.key, required this.songLyricsParser});

  @override
  State<StartPresentationScreen> createState() => _StartPresentationScreenState();
}

class _StartPresentationScreenState extends State<StartPresentationScreen> with WidgetsBindingObserver {
  bool _canPresent = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    context.read<PresentationProvider>().canPresent.then((canPresent) => setState(() => _canPresent = canPresent));
  }

  @override
  void initState() {
    super.initState();

    context.read<PresentationProvider>().canPresent.then((canPresent) => setState(() => _canPresent = canPresent));

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
        leading: const CustomBackButton(),
        title: Text('Prezentovat', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
        leadingWidth: 24 + 4 * kDefaultPadding,
        titleSpacing: 0,
        actions: [
          HighlightableIconButton(
            onTap: _canPresent
                ? () {
                    context.read<PresentationProvider>().start(widget.songLyricsParser);
                    context.pop();
                  }
                : null,
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
