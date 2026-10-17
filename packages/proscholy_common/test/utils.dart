import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

var _storeCounter = 0;

SongLyric createSongLyric({int id = 1, String name = 'Píseň', String? lyrics}) {
  return SongLyric(
    id: id,
    displayId: '$id',
    displayName: name,
    name: name,
    lyrics: lyrics,
    lang: 'cs',
    langDescription: 'Čeština',
    dbType: 0,
    hasChords: false,
    isArrangement: false,
    song: ToOne(),
    settings: ToOne(),
    authors: ToMany(),
    tags: ToMany(),
    externals: ToMany(),
    songbookRecords: ToMany(),
    playlistRecords: ToMany(),
  );
}

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
