import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/providers/svgs.dart';

import '../utils.dart';

List<int> _zip(Map<String, String> svgs) {
  final archive = Archive();

  for (final MapEntry(key: name, value: svg) in svgs.entries) {
    archive.add(ArchiveFile.bytes(name, GZipEncoder().encodeBytes(utf8.encode(svg))));
  }

  return ZipEncoder().encodeBytes(archive);
}

void main() {
  late Directory directory;
  late ProviderContainer container;

  setUp(() async {
    directory = await mockDocumentsDirectory();
    container = ProviderContainer.test();
  });

  test('svgs from assets are stored during first start', () async {
    mockAsset('assets/svg.zip', _zip({'1.svg.gz': '<svg>1</svg>'}));

    container.listen(svgsProvider, (_, _) {});

    await eventually(() => expect(container.read(svgsProvider).keys, ['1.svg.gz']));

    expect(File('${directory.path}/musicNotes/1.svg.gz').existsSync(), isTrue);
    expect(container.read(svgProvider(1)), '<svg>1</svg>');
    expect(container.read(svgProvider(2)), '');
  });

  test('stored svgs are loaded', () async {
    File('${directory.path}/musicNotes/2.svg.gz')
      ..createSync(recursive: true)
      ..writeAsBytesSync(GZipEncoder().encodeBytes(utf8.encode('<svg>2</svg>')));

    container.listen(svgsProvider, (_, _) {});

    await eventually(() => expect(container.read(svgsProvider).keys, ['2.svg.gz']));

    expect(container.read(svgProvider(2)), '<svg>2</svg>');
  });

  test('empty archive in assets', () async {
    mockAsset('assets/svg.zip', _zip({}));

    container.listen(svgsProvider, (_, _) {});

    await eventually(() => expect(Directory('${directory.path}/musicNotes').existsSync(), isTrue));

    expect(container.read(svgsProvider), isEmpty);
  });
}
