import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/song_lyric/externals/audio_player.dart';
import 'package:zpevnik/components/song_lyric/externals/youtube_player.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/providers/display_screen_status.dart';
import 'package:zpevnik/utils/extensions.dart';
import 'package:zpevnik/utils/url_launcher.dart';

class ExternalWidget extends StatefulWidget {
  final External external;

  const ExternalWidget({super.key, required this.external});

  @override
  State<ExternalWidget> createState() => _ExternalWidgetState();
}

class _ExternalWidgetState extends State<ExternalWidget> {
  // to make externals work in collapsed player, they are always in the widget tree, but are moved out of screen when not showing
  // make sure to not load them if they are not visible yet
  bool _lazyLoaded = false;

  late final ProviderSubscription<bool> _showingExternalsSubscription;

  @override
  void initState() {
    super.initState();

    _showingExternalsSubscription =
        context.providers.listen(displayScreenStatusProvider.select((status) => status.showingExternals), (_, next) {
      if (!_lazyLoaded && next) setState(() => _lazyLoaded = true);
    });
  }

  @override
  void dispose() {
    _showingExternalsSubscription.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Highlightable(
            highlightBackground: true,
            padding: const EdgeInsets.all(kDefaultPadding),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(kDefaultRadius)),
            isEnabled: widget.external.url != null,
            onTap: () => launch(widget.external.url!),
            child: Row(
              children: [
                Icon(switch (widget.external.mediaType) {
                  MediaType.youtube => FontAwesomeIcons.youtube,
                  _ => FontAwesomeIcons.music,
                }),
                const SizedBox(width: kDefaultPadding),
                Expanded(child: Text(widget.external.name)),
                if (widget.external.url != null) const Icon(Icons.open_in_new),
              ],
            ),
          ),
          if (_lazyLoaded)
            switch (widget.external.mediaType) {
              MediaType.mp3 => AudioPlayerWrapper(external: widget.external),
              MediaType.youtube => YoutubePlayerWrapper(external: widget.external),
              _ => throw UnimplementedError('media type is not supported for `ExternalWidget`'),
            },
        ],
      ),
    );
  }
}
