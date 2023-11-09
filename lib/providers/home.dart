import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zpevnik/providers/app_dependencies.dart';

part 'home.g.dart';

const _homeSectionsKey = 'home_screen_sections';

const _defaultHomeSections = HomeSection.values;

enum HomeSection {
  news('Novinky'),
  recent('Poslední položky'),
  playlists('Moje seznamy'),
  songbooks('Zpěvníky');

  final String description;

  const HomeSection(this.description);
}

@riverpod
class HomeSectionSettings extends _$HomeSectionSettings {
  SharedPreferences get _sharedPreferences {
    return ref.read(appDependenciesProvider).sharedPreferences;
  }

  @override
  List<HomeSection> build() {
    final homeSections = _sharedPreferences
        .getStringList(_homeSectionsKey)
        ?.map((index) => HomeSection.values[int.parse(index)])
        .toList();

    return homeSections ?? _defaultHomeSections;
  }

  void add(HomeSection homeSection) {
    state = [...state, homeSection];

    _save();
  }

  void remove(HomeSection homeSection) {
    state = [
      for (final section in state)
        if (section != homeSection) section
    ];

    _save();
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex--;

    state = [
      for (int i = 0; i < state.length; i++)
        if (i == newIndex)
          state[oldIndex]
        else if (i > newIndex && i <= oldIndex)
          state[i - 1]
        else if (i >= oldIndex && i < newIndex)
          state[i + 1]
        else
          state[i]
    ];

    _save();
  }

  void _save() {
    _sharedPreferences.setStringList(_homeSectionsKey, [for (final homeSection in state) '${homeSection.index}']);
  }
}
