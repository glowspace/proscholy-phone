import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_list_view.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/utils/extensions.dart';

class UpdatedSongLyricsScreen extends StatelessWidget {
  const UpdatedSongLyricsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isTablet = MediaQuery.of(context).isTablet;
    final backgroundColor = theme.brightness.isLight ? theme.colorScheme.surface : theme.scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isTablet ? backgroundColor : null,
        elevation: isTablet ? 0 : null,
        leading: const CustomBackButton(),
        title: Text('Naposledy aktualizované', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
      ),
      backgroundColor: isTablet ? backgroundColor : null,
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => UpdatedSongLyricsProvider(context.read<DataProvider>()),
          builder: (_, __) => const SongLyricsListView<UpdatedSongLyricsProvider>(),
        ),
      ),
    );
  }
}
