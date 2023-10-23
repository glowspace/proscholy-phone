import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/now_playing.dart';
import 'package:zpevnik/utils/extensions.dart';

const _backgroundColor = Color(0xff232380);
const _backgroundHighlightColor = Color(0xff1a1a60);

class NowPlayingSection extends StatefulWidget {
  final NowPlayingController? controller;
  final bool pushShouldReplace;

  const NowPlayingSection({super.key, this.controller, this.pushShouldReplace = false});

  @override
  State<NowPlayingSection> createState() => _NowPlayingSectionState();
}

class _NowPlayingSectionState extends State<NowPlayingSection> {
  late NowPlayingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? NowPlayingController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<SongLyric?>(
      valueListenable: _controller,
      builder: (_, songLyric, __) => AnimatedCrossFade(
        duration: kDefaultAnimationDuration,
        crossFadeState: songLyric == null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstChild: Container(),
        secondChild: Container(
          margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Highlightable(
            highlightBackground: true,
            highlightColor: theme.brightness.isLight ? _backgroundHighlightColor : _backgroundColor,
            padding: const EdgeInsets.fromLTRB(2 * kDefaultPadding, kDefaultPadding, kDefaultPadding, kDefaultPadding),
            onTap: () => _pushSongLyric(songLyric!),
            child: Container(
              color: theme.brightness.isLight ? _backgroundColor : _backgroundHighlightColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Právě teď na CSM',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
                        ),
                        const SizedBox(height: kDefaultPadding / 2),
                        Text(
                          songLyric?.name ?? '',
                          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: kDefaultPadding),
                  Image.asset('assets/images/logos/csmhk.png', height: 56),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _pushSongLyric(SongLyric songLyric) {
    if (widget.pushShouldReplace) {
      Navigator.of(context).pushReplacementNamed('/song_lyric', arguments: songLyric);
    } else {
      Navigator.of(context).pushNamed('/song_lyric', arguments: songLyric);
    }
  }
}
