import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'menu_collapsed.g.dart';

@Riverpod(keepAlive: true)
class MenuCollapsed extends _$MenuCollapsed {
  // TODO: load and store this in shared preferences
  @override
  bool build() => true;

  void toggle() {
    state = !state;
  }
}
