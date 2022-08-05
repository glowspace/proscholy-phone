import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';
import 'package:zpevnik/utils/extensions.dart';

const _backgroundColor = Color(0xff232380);
const _backgroundHighlightColor = Color(0xff1a1a60);

final _wssUri = Uri.parse('wss://mass-event.proscholy.cz');

class NowPlayingSection extends StatefulWidget {
  const NowPlayingSection({Key? key}) : super(key: key);

  @override
  State<NowPlayingSection> createState() => _NowPlayingSectionState();
}

class _NowPlayingSectionState extends State<NowPlayingSection> {
  late final WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();

    _channel = WebSocketChannel.connect(_wssUri);
    _channel.sink.add('ask');
  }

  @override
  void dispose() {
    _channel.sink.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder(
      stream: _channel.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        final songLyric = context.read<DataProvider>().getSongLyricById(int.tryParse(snapshot.data as String) ?? -1);

        if (songLyric == null) return Container();

        return Container(
          margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Highlightable(
            onTap: () => Navigator.of(context).pushNamed(
              '/song_lyric',
              arguments: SongLyricScreenArguments([songLyric], 0),
            ),
            padding: const EdgeInsets.fromLTRB(2 * kDefaultPadding, kDefaultPadding, kDefaultPadding, kDefaultPadding),
            color: theme.brightness.isLight ? _backgroundColor : _backgroundHighlightColor,
            highlightColor: theme.brightness.isLight ? _backgroundHighlightColor : _backgroundColor,
            highlightBackground: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Právě teď na CSM',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
                      ),
                      const SizedBox(height: kDefaultPadding / 2),
                      Text(
                        songLyric.name,
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
        );
      },
    );
  }
}
