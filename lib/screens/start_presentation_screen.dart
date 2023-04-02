import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/presentation/settings.dart';
import 'package:zpevnik/components/song_lyric/utils/parser.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/presentation.dart';

class StartPresentationScreen extends StatelessWidget {
  final SongLyricsParser songLyricsParser;

  const StartPresentationScreen({super.key, required this.songLyricsParser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text('Prezentovat', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
        leadingWidth: 24 + 4 * kDefaultPadding,
        titleSpacing: 0,
        actions: [
          HighlightableIconButton(
            onTap: () {
              context.read<PresentationProvider>().start(songLyricsParser);
              Navigator.of(context).pop();
            },
            padding: const EdgeInsets.all(kDefaultPadding),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: const SafeArea(child: PresentationSettingsWidget()),
    );
  }
}
