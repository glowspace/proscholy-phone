import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/home/nearby_song_lyrics/nearby_publisher_cell.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/nearby_song_lyrics.dart';

class NearbySongLyricsSection extends ConsumerStatefulWidget {
  const NearbySongLyricsSection({Key? key}) : super(key: key);

  @override
  ConsumerState<NearbySongLyricsSection> createState() => _NearbySongLyricsSectionState();
}

class _NearbySongLyricsSectionState extends ConsumerState<NearbySongLyricsSection> {
  @override
  void initState() {
    super.initState();

    ref.read(songLyricsDiscovererProvider.notifier).startDiscovering();
  }

  @override
  void dispose() {
    ref.read(songLyricsDiscovererProvider.notifier).stopDiscovering();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final nearbyPublishers = ref.watch(songLyricsDiscovererProvider).toList();

    return AnimatedCrossFade(
      duration: kDefaultAnimationDuration,
      crossFadeState: nearbyPublishers.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Container(),
      secondChild: Container(
        margin: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.colorScheme.surface,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding),
              child: Text('Právě teď v okolí', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: nearbyPublishers.length,
              itemBuilder: (_, index) => NearbyPublisherCell(publisher: nearbyPublishers[index]),
            )
          ],
        ),
      ),
    );
  }
}
