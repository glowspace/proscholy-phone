import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/song_lyrics.dart';
import 'package:proscholy_common/providers/sort.dart';
import 'package:proscholy_common/providers/svgs.dart';
import 'package:proscholy_common/utils/data.dart';

import '../utils.dart';

class _FakeSvgs extends Svgs {
  @override
  Map<String, FileSystemEntity> build() => {'3.svg.gz': File('3.svg.gz')};
}

void main() {
  test('song lyrics without lyrics or files are listed only with music notes', () async {
    final appDependencies = await createAppDependencies();

    await storeSongLyrics(appDependencies.store, [
      createSongLyric(id: 1, name: 'A', lyrics: 'Text'),
      createSongLyric(id: 2, name: 'B'),
      createSongLyric(id: 3, name: 'C'),
    ]);

    final container = createContainer(appDependencies, overrides: [svgsProvider.overrideWith(_FakeSvgs.new)]);

    container.read(sortProvider.notifier).change(SortType.alpha);

    expect((await container.read(songLyricsProvider.future)).map((songLyric) => songLyric.id), [1, 3]);
  });
}
