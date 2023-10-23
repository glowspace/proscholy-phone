import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/song_lyric/externals/audio_player.dart';
import 'package:zpevnik/components/song_lyric/externals/youtube_player.dart';
import 'package:zpevnik/components/song_lyric/utils/active_player_controller.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/providers/display_screen_status.dart';
import 'package:zpevnik/utils/url_launcher.dart';

class ExternalWidget extends ConsumerWidget {
  final External external;

  const ExternalWidget({super.key, required this.external});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(displayScreenStatusProvider.select((status) => status.showingExternals));
    final isPlaying = ref.watch(activePlayerProvider.select((activePlayer) => activePlayer?.external == external));

    return Card(
      child: Column(
        children: [
          Highlightable(
            highlightBackground: true,
            padding: const EdgeInsets.all(kDefaultPadding),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(kDefaultRadius)),
            isEnabled: external.url != null,
            onTap: () => launch(external.url!),
            child: Row(
              children: [
                Icon(switch (external.mediaType) {
                  MediaType.youtube => FontAwesomeIcons.youtube,
                  _ => FontAwesomeIcons.music,
                }),
                const SizedBox(width: kDefaultPadding),
                Expanded(child: Text(external.name)),
                if (external.url != null) const Icon(Icons.open_in_new),
              ],
            ),
          ),
          if (isVisible || isPlaying)
            switch (external.mediaType) {
              MediaType.mp3 => AudioPlayerWrapper(external: external),
              MediaType.youtube => YoutubePlayerWrapper(key: const Key('test'), external: external),
              _ => throw UnimplementedError('media type is not supported for `ExternalWidget`'),
            },
        ],
      ),
    );
  }
}
