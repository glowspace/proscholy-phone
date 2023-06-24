import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'full_screen.g.dart';

@Riverpod(keepAlive: true)
class FullScreen extends _$FullScreen {
  @override
  bool build() => false;

  void disable() => state = false;

  void toggle() => state = !state;
}
