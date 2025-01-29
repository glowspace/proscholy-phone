import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';

part 'generated/sort.g.dart';

const _sortTypeKey = 'sort_type';

@Riverpod(keepAlive: true)
class Sort extends _$Sort {
  @override
  SortType build() {
    final prefs = ref.read(appDependenciesProvider).sharedPreferences;
    final sortTypeData = prefs.getInt(_sortTypeKey);

    ref.listenSelf((_, next) => prefs.setInt(_sortTypeKey, next.index));

    if (sortTypeData != null) return SortType.values[sortTypeData];

    return SortType.random;
  }

  void change(SortType sortType) => state = sortType;

  void next() => state = SortType.values[(state.index + 1) % SortType.values.length];
}
