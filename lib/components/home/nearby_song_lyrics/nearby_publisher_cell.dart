import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/nearby_song_lyrics.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';

class NearbyPublisherCell extends ConsumerWidget {
  final NearbySongLyricsPublisher publisher;

  const NearbyPublisherCell({Key? key, required this.publisher}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final songLyric = context.watch<DataProvider>().getSongLyricById(publisher.songLyricId);

    return Highlightable(
      onTap: () => _pushSongLyric(context, ref, songLyric!),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      color: theme.colorScheme.surface,
      highlightBackground: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              songLyric?.name ?? '',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: kDefaultPadding / 2),
          Text(
            publisher.publisherName,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _pushSongLyric(BuildContext context, WidgetRef ref, SongLyric songLyric) {
    final arguments = SongLyricScreenArguments([songLyric], 0, shouldShowBanner: true);

    ref.read(nearbySongLyricProvider.notifier).connect(publisher.publisherUUID);

    Navigator.of(context).pushNamed('/song_lyric', arguments: arguments);
    // TODO: find out when to disconnect
    // .then((_) => ref.read(nearbySongLyricProvider.notifier).disconnect());
  }
}
