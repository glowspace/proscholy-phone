import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/providers/app_dependencies.dart';

part 'menu_collapsed.g.dart';

const _menuCollapsedKey = 'menu_collapsed';

@Riverpod(keepAlive: true)
class MenuCollapsed extends _$MenuCollapsed {
  @override
  bool build() => ref.read(appDependenciesProvider).sharedPreferences.getBool(_menuCollapsedKey) ?? false;

  void toggle() {
    state = !state;

    ref.read(appDependenciesProvider).sharedPreferences.setBool(_menuCollapsedKey, state);
  }
}
