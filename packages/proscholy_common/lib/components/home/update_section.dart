import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/components/section.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/links.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/svgs.dart';
import 'package:proscholy_common/providers/update.dart';
import 'package:proscholy_common/utils/extensions.dart';
import 'package:proscholy_common/utils/url_launcher.dart';

class UpdateSection extends ConsumerStatefulWidget {
  const UpdateSection({super.key});

  @override
  ConsumerState<UpdateSection> createState() => _UpdateSectionState();
}

class _UpdateSectionState extends ConsumerState<UpdateSection> {
  bool _isHidden = false;

  @override
  Widget build(BuildContext context) {
    return ref.watch(updateProvider).when(
          data: (updateStatus) {
            final updatedSongLyrics = switch (updateStatus) {
              Updating() => null,
              Updated(songLyrics: final songLyrics) => songLyrics
                  .where((songLyric) => songLyric.shouldAppearToUser || ref.read(svgProvider(songLyric.id)).isNotEmpty)
                  .toList(),
            };

            return _build(context, updatedSongLyrics: updatedSongLyrics);
          },
          error: (error, stackTrace) => _build(context, error: error, stackTrace: stackTrace),
          loading: () => _build(context, updatedSongLyrics: []),
        );
  }

  Widget _build(BuildContext context, {List<SongLyric>? updatedSongLyrics, Object? error, StackTrace? stackTrace}) {
    final theme = Theme.of(context);

    // don't show anything if no song lyric was updated
    final isShowing = !_isHidden && (updatedSongLyrics?.isNotEmpty ?? true);
    final hasSonglyrics = updatedSongLyrics?.isNotEmpty ?? false;
    final hasError = error != null;

    final text = updatedSongLyrics?.isEmpty ?? true
        ? (error == null ? 'Probíhá stahování písní' : 'Při aktualizaci nastala chyba')
        : 'Počet aktualizovaných písní: ${updatedSongLyrics!.length}';

    final version = context.providers.read(appDependenciesProvider).packageInfo.version;
    final platform = theme.platform == TargetPlatform.iOS ? 'iOS' : 'android';
    final url = 'https://$platform.$baseUrl/v$version';

    final description = Uri.encodeComponent('Chyba: $error\n\nStackTrace: $stackTrace');

    return AnimatedCrossFade(
      crossFadeState: isShowing ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: kDefaultAnimationDuration,
      firstChild: Section(
        padding: const EdgeInsets.all(kDefaultPadding),
        margin: const EdgeInsets.symmetric(vertical: 2 / 3 * kDefaultPadding),
        children: [
          Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: theme.textTheme.bodyMedium),
                  if (hasSonglyrics)
                    HighlightableWidget(
                      foregroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.only(top: 2 / 3 * kDefaultPadding),
                      onTap: () => context.push('/updated_song_lyrics', arguments: updatedSongLyrics),
                      child: const Text('Zobrazit'),
                    ),
                  if (hasError)
                    HighlightableWidget(
                      foregroundColor: red,
                      padding: const EdgeInsets.only(top: 2 / 3 * kDefaultPadding),
                      onTap: () => launch(
                          '$reportUrl?customfield_10056=$url&summary=Chyba při aktualizaci písní&description=$description'),
                      child: const Text('Nahlásit chybu'),
                    ),
                ],
              ),
            ),
            if (isShowing && (hasSonglyrics || hasError))
              HighlightableWidget(
                onTap: () => setState(() => _isHidden = true),
                icon: const Icon(Icons.close),
              )
          ]),
          if (!hasSonglyrics && !hasError)
            Container(
              padding: const EdgeInsets.only(top: kDefaultPadding / 2),
              child: const LinearProgressIndicator(),
            ),
        ],
      ),
      secondChild: const SizedBox(),
    );
  }
}
