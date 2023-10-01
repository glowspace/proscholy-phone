import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/components/song_lyric/utils/auto_scroll.dart';
import 'package:zpevnik/models/song_lyric.dart';

part 'auto_scroll.g.dart';

// provides different `AutoScrollController` for given songLyric
@riverpod
AutoScrollController autoScrollController(AutoScrollControllerRef ref, SongLyric songLyric) => AutoScrollController();
