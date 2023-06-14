import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

part 'app_dependencies.freezed.dart';
part 'app_dependencies.g.dart';

// Value will be overriden in `main.dart` with real.
@Riverpod(keepAlive: true)
AppDependencies appDependencies(AppDependenciesRef ref) => throw UnimplementedError();

@freezed
class AppDependencies with _$AppDependencies {
  const factory AppDependencies({
    required SharedPreferences sharedPreferences,
    required Store store,
    required Database ftsDatabase,
  }) = _AppDependencies;
}
