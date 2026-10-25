import 'dart:io';
import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';

// the app started again runs in isolate of new Flutter engine
Future<List<String>> _playlistNamesOfAppStartedAgain(String directory) => Isolate.run(() async {
  final store = await openOrAttachStore(directory: directory);
  final names = store.box<Playlist>().getAll().map((playlist) => playlist.name).toList();

  store.close();

  return names;
});

void main() {
  test('store that is still open in the process is attached', () async {
    final directory = await Directory.systemTemp.createTemp('proscholy_store_');

    // store of the previous start of the app
    final store = await openOrAttachStore(directory: directory.path);

    addTearDown(() {
      store.close();
      directory.deleteSync(recursive: true);
    });

    store.box<Playlist>().put(Playlist(id: 1, name: 'Mše', rank: 0, records: ToMany()));

    expect(await _playlistNamesOfAppStartedAgain(directory.path), ['Mše']);
  });
}
