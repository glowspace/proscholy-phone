import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart' show getObjectBoxModel, openStore;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

part 'generated/app_dependencies.freezed.dart';
part 'generated/app_dependencies.g.dart';

// Value will be overriden in `main.dart` with real.
@Riverpod(keepAlive: true)
AppDependencies appDependencies(Ref ref) => throw UnimplementedError();

@Freezed(equal: true)
sealed class AppDependencies with _$AppDependencies {
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

// Android can start the app again in the same process, e.g. from a link, while the store of the previous start is open
Future<Store> openOrAttachStore({String? directory}) async {
  final path = directory ?? (await defaultStoreDirectory()).path;

  if (Store.isOpen(path)) return Store.attach(getObjectBoxModel(), path);

  return openStore(directory: path);
}
