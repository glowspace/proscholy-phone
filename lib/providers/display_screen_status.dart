import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'display_screen_status.g.dart';
part 'display_screen_status.freezed.dart';

@riverpod
class DisplayScreenStatus extends _$DisplayScreenStatus {
  @override
  DisplayScreenStatusModel build() {
    return const DisplayScreenStatusModel(fullScreen: false, showingExternals: false);
  }

  void toggleFullScreen() => state = state.copyWith(fullScreen: !state.fullScreen);

  void enableFullScreen() => state = state.copyWith(fullScreen: true);

  void toggleShowingExternals() => state = state.copyWith(showingExternals: !state.showingExternals);

  void showExternals() => state = state.copyWith(showingExternals: true);

  void hideExternals() => state = state.copyWith(showingExternals: false);
}

@freezed
class DisplayScreenStatusModel with _$DisplayScreenStatusModel {
  const factory DisplayScreenStatusModel({
    required bool fullScreen,
    required bool showingExternals,
  }) = _DisplayScreenStatusModel;
}
