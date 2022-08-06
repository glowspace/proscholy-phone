import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/now_playing.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';
import 'package:zpevnik/utils/extensions.dart';

const _backgroundColor = Color(0xff232380);
const _backgroundHighlightColor = Color(0xff1a1a60);

class NowPlayingSection extends StatefulWidget {
  final NowPlayingController? controller;
  final bool pushShouldReplace;

  const NowPlayingSection({Key? key, this.controller, this.pushShouldReplace = false}) : super(key: key);

  @override
  State<NowPlayingSection> createState() => _NowPlayingSectionState();
}

class _NowPlayingSectionState extends State<NowPlayingSection> {
  late NowPlayingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? NowPlayingController(context.read<DataProvider>());
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
            onTap: () => _pushSongLyric(context, songLyric!),
            padding: const EdgeInsets.fromLTRB(2 * kDefaultPadding, kDefaultPadding, kDefaultPadding, kDefaultPadding),
            color: theme.brightness.isLight ? _backgroundColor : _backgroundHighlightColor,
            highlightColor: theme.brightness.isLight ? _backgroundHighlightColor : _backgroundColor,
            highlightBackground: true,
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
    );
  }

  void _pushSongLyric(BuildContext context, SongLyric songLyric) {
    final arguments = SongLyricScreenArguments([songLyric], 0, shouldShowBanner: true);

    if (widget.pushShouldReplace) {
      Navigator.of(context).pushReplacementNamed('/song_lyric', arguments: arguments);
    } else {
      Navigator.of(context).pushNamed('/song_lyric', arguments: arguments);
    }
  }
}
