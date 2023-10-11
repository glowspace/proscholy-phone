import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/song_lyric/externals/audio_player.dart';
import 'package:zpevnik/components/song_lyric/externals/youtube_player.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/utils/url_launcher.dart';

class ExternalWidget extends StatelessWidget {
  final External external;

  const ExternalWidget({super.key, required this.external});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Highlightable(
            highlightBackground: true,
            padding: const EdgeInsets.all(kDefaultPadding),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(kDefaultRadius)),
            isEnabled: external.url != null,
            onTap: () => launch(context, external.url!),
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
          switch (external.mediaType) {
            MediaType.mp3 => AudioPlayerWrapper(external: external),
            MediaType.youtube => YoutubePlayerWrapper(external: external),
            _ => throw UnimplementedError('media type is not supported for `ExternalWidget`'),
          },
        ],
      ),
    );
  }
}
