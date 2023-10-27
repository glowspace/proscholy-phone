import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/components/song_lyric/utils/auto_scroll.dart';
import 'package:zpevnik/models/model.dart';

part 'auto_scroll.g.dart';

// provides different `AutoScrollController` for given displayable item
@riverpod
AutoScrollController autoScrollController(AutoScrollControllerRef ref, DisplayableItem displayableItem) {
  return AutoScrollController();
}
