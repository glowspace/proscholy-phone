import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/utils/platform_state.dart';

class SongLyricScreen extends StatefulWidget {
  final SongLyric songLyric;

  const SongLyricScreen({Key key, this.songLyric}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongLyricScreen();
}

class _SongLyricScreen extends State<SongLyricScreen> with PlatformStateMixin {
  _SongLyricScreen();

  @override
  Widget androidWidget(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(widget.songLyric.id.toString())),
      body: _body(context));

  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.songLyric.id.toString()),
        transitionBetweenRoutes: false,
      ),
      child: _body(context));

  Widget _body(BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          child: Text(
            '${widget.songLyric.name}\n\n${widget.songLyric.lyrics}',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  // Widget _body(BuildContext context) => SafeArea(
  //       child: Container(
  //         margin: EdgeInsets.only(top: 50),
  //         child: RichText(
  //           text: TextSpan(
  //             text: 'Bless the ',
  //             children: [
  //               WidgetSpan(
  //                 child: Stack(
  //                   children: [
  //                     Text('L', style: TextStyle(color: Colors.white)),
  //                     Transform.translate(
  //                       offset: Offset(0, -17),
  //                       child:
  //                           Text('Ami', style: TextStyle(color: Colors.white)),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               TextSpan(text: 'ord'),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
}
