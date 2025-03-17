import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/svgs.g.dart';

const _svgsPath = 'musicNotes';

@Riverpod(keepAlive: true)
class Svgs extends _$Svgs {
  @override
  Map<String, FileSystemEntity> build() {
    () async {
      final directory = await getApplicationDocumentsDirectory();

      try {
        // try removing zip from old version
        File('${directory.path}/$_svgsPath.zip');
        // ignore: empty_catches
      } catch (e) {}

      final svgsDir = Directory('${directory.path}/$_svgsPath');
      List<FileSystemEntity> files;

      try {
        files = svgsDir.listSync().where((file) => file.path.endsWith('.svg.gz')).toList();
      } on PathNotFoundException {
        await storeSvgs((await rootBundle.load('assets/svg.zip')).buffer.asUint8List());

        files = svgsDir.listSync().where((file) => file.path.endsWith('.svg.gz')).toList();
      }

      final filesMap = <String, FileSystemEntity>{};

      for (final file in files) {
        filesMap[file.path.split('/').last] = file;
      }

      state = filesMap;
    }();

    return {};
  }

  Future<void> storeSvgs(List<int> bytes) async {
    final archive = ZipDecoder().decodeBytes(bytes);
    final directory = await getApplicationDocumentsDirectory();

    for (final entry in archive) {
      if (entry.isFile) {
        final file = File('${directory.path}/$_svgsPath/${entry.name}');
        await file.create(recursive: true);
        await file.writeAsBytes(entry.content);
      }
    }
  }
}

@riverpod
class Svg extends _$Svg {
  @override
  String build(int songLyricId) {
    print(songLyricId);
    final file = ref.watch(svgsProvider)['$songLyricId.svg.gz'];

    if (file != null) return utf8.decode(GZipDecoder().decodeBytes(File(file.path).readAsBytesSync()));

    return '';
  }
}
