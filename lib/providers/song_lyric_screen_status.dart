import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_lyric_screen_status.g.dart';
part 'song_lyric_screen_status.freezed.dart';

@riverpod
class SongLyricScreenStatus extends _$SongLyricScreenStatus {
  @override
  SongLyricScreenStatusModel build() {
    return const SongLyricScreenStatusModel(fullScreen: false, showingExternals: false);
  }

  void toggleFullScreen() => state = state.copyWith(fullScreen: !state.fullScreen);

  void enableFullScreen() => state = state.copyWith(fullScreen: true);

  void toggleShowingExternals() => state = state.copyWith(showingExternals: !state.showingExternals);

  void showExternals() => state = state.copyWith(showingExternals: true);

  void hideExternals() => state = state.copyWith(showingExternals: false);
}

@freezed
class SongLyricScreenStatusModel with _$SongLyricScreenStatusModel {
  const factory SongLyricScreenStatusModel({
    required bool fullScreen,
    required bool showingExternals,
  }) = _SongLyricScreenStatusModel;
}
