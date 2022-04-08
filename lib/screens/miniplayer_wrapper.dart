import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/player.dart';
import 'package:zpevnik/screens/content.dart';

class MiniPlayerWrapper extends StatelessWidget {
  MiniPlayerWrapper({Key? key}) : super(key: key);

  final _navigatorKey = GlobalKey();
  final _playerExpandProgress = ValueNotifier<double>(0.0);
  final _miniPlayerController = MiniplayerController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlayerProvider(_miniPlayerController, _playerExpandProgress),
      builder: (_, __) => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Navigator(
              key: _navigatorKey,
              onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                settings: settings,
                builder: (BuildContext context) => ContentScreen(),
              ),
            ),
            Consumer<PlayerProvider>(
              builder: (_, playerProvider, __) => Miniplayer(
                minHeight: playerProvider.hasActivePlayer ? 64 : 0,
                maxHeight: 500,
                builder: playerProvider.builder,
                controller: _miniPlayerController,
                valueNotifier: _playerExpandProgress,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
