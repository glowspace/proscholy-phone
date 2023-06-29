import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'menu.g.dart';

@Riverpod(keepAlive: true)
class MenuCollapsed extends _$MenuCollapsed {
  @override
  bool build() => false;

  void toggle() => state = !state;
}
