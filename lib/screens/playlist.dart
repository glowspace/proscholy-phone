import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_list_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/song_lyrics.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songLyricsProvider = context.read<PlaylistSongLyricsProvider>();

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: kDefaultPadding),
              SearchField(
                key: const Key('searchfield'),
                isInsideSearchScreen: true,
                onChanged: songLyricsProvider.search,
                onSubmitted: (_) => _maybePushMatchedSonglyric(context),
              ),
              const SizedBox(height: kDefaultPadding),
              const Expanded(child: SongLyricsListView<PlaylistSongLyricsProvider>()),
            ],
          ),
        ),
      ),
    );
  }

  void _maybePushMatchedSonglyric(BuildContext context) {
    final songLyricsProvider = context.read<PlaylistSongLyricsProvider>();

    if (songLyricsProvider.matchedById != null) {
      Navigator.pushNamed(context, '/song_lyric', arguments: songLyricsProvider.matchedById);
    }
  }
}
