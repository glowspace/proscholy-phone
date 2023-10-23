import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
    // reference to simple key-value storage
    required SharedPreferences sharedPreferences,
    // objectbox store used as NoSQL database
    required Store store,
    // FTS4 database that is used during song lyrics search
    required Database ftsDatabase,
    // info about application (used for version and build number)
    required PackageInfo packageInfo,
  }) = _AppDependencies;
}
