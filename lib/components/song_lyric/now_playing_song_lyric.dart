import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';

class NowPlayingSongLyric extends StatelessWidget {
  final SongLyric songLyric;
  const NowPlayingSongLyric({Key? key, required this.songLyric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      constraints: const BoxConstraints(minWidth: double.infinity),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Highlightable(
        onTap: () => _pushSongLyric(context, songLyric),
        padding: const EdgeInsets.fromLTRB(2 * kDefaultPadding, kDefaultPadding, kDefaultPadding, kDefaultPadding),
        color: Theme.of(context).colorScheme.surface,
        highlightBackground: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Následující píseň', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            const SizedBox(height: kDefaultPadding / 2),
            Text(
              songLyric.name,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _pushSongLyric(BuildContext context, SongLyric songLyric) {
    final arguments = SongLyricScreenArguments([songLyric], 0, shouldShowBanner: true);

    Navigator.of(context).pushReplacementNamed('/song_lyric', arguments: arguments);
  }
}
