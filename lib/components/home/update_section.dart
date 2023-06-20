import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/update.dart';
import 'package:zpevnik/utils/url_launcher.dart';

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
              Updated(songLyrics: final songLyrics) => songLyrics,
            };

            return _build(context, updatedSongLyrics: updatedSongLyrics);
          },
          error: (error, stackTrace) {
            if (!kDebugMode) Sentry.captureException(error, stackTrace: stackTrace);

            return _build(context, error: error);
          },
          loading: () => _build(context, updatedSongLyrics: []),
        );
  }

  Widget _build(BuildContext context, {List<SongLyric>? updatedSongLyrics, Object? error}) {
    final theme = Theme.of(context);

    // don't show anything if no song lyric was updated
    final isShowing = !_isHidden && (updatedSongLyrics?.isNotEmpty ?? true);
    final hasSonglyrics = updatedSongLyrics?.isNotEmpty ?? false;
    final hasError = error != null;

    final text = updatedSongLyrics == null
        ? (error == null ? 'Probíhá stahování písní' : 'Při aktualizaci nastala chyba')
        : 'Počet aktualizovaných písní: ${updatedSongLyrics.length}';

    return AnimatedCrossFade(
      crossFadeState: isShowing ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: kDefaultAnimationDuration,
      firstChild: Padding(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        child: Section(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text, style: theme.textTheme.bodyMedium),
                      if (hasSonglyrics)
                        HighlightableTextButton(
                          foregroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.only(top: 2 / 3 * kDefaultPadding),
                          onTap: () => context.push('/updated_song_lyrics', extra: updatedSongLyrics),
                          child: const Text('Zobrazit'),
                        ),
                      if (hasError)
                        HighlightableTextButton(
                          foregroundColor: red,
                          padding: const EdgeInsets.only(top: 2 / 3 * kDefaultPadding),
                          onTap: () =>
                              launch(context, '$reportUrl?summary=Chyba při aktualizaci písní&description=$error'),
                          child: const Text('Nahlásit chybu'),
                        ),
                    ],
                  ),
                ),
                if (isShowing && (hasSonglyrics || hasError))
                  HighlightableIconButton(
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
        ),
      ),
      secondChild: const SizedBox(),
    );
  }
}
