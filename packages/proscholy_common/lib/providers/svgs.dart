import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/svgs.g.dart';

const _svgsPath = 'musicNotes.zip';

@Riverpod(keepAlive: true)
class Svgs extends _$Svgs {
  @override
  Map<String, ArchiveFile> build() {
    () async {
      Archive archive;

      try {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$_svgsPath');

        archive = ZipDecoder().decodeBytes(await file.readAsBytes());
      } catch (e) {
        archive = ZipDecoder().decodeBytes((await rootBundle.load('assets/svg.zip')).buffer.asUint8List());
      }

      final filesMap = <String, ArchiveFile>{};

      for (final file in archive.files) {
        filesMap[file.name] = file;
      }

      state = filesMap;
    }();

    return {};
  }

  Future<void> update(List<int> bytes) async {
    final archive = ZipDecoder().decodeBytes(bytes);
    final filesMap = <String, ArchiveFile>{...state};

    for (final file in archive.files) {
      filesMap[file.name] = file;
    }

    state = filesMap;

    final updatedArchive = Archive();

    for (final file in filesMap.values) {
      updatedArchive.addFile(file);
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_svgsPath');

    await file.writeAsBytes(ZipEncoder().encode(updatedArchive));
  }
}

@riverpod
class Svg extends _$Svg {
  @override
  String build(int songLyricId) {
    final file = ref.watch(svgsProvider)['$songLyricId.svg.gz'];

    if (file != null) return utf8.decode(GZipDecoder().decodeBytes(file.content));

    return '';
  }
}
