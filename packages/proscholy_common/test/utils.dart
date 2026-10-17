import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

var _storeCounter = 0;

// opens new empty in-memory store, requires objectbox library installed on host (see `init_test.sh`)
Future<Store> openTestStore() async {
  final store = await openStore(directory: 'memory:test_${_storeCounter++}');

  addTearDown(store.close);

  return store;
}

// opens new empty in-memory database that can be used as `ftsDatabase`
Future<Database> openTestFtsDatabase() async {
  sqfliteFfiInit();

  final database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

  addTearDown(database.close);

  return database;
}
