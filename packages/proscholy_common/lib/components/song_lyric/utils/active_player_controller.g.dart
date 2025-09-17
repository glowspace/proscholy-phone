// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_player_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActivePlayer)
const activePlayerProvider = ActivePlayerProvider._();

final class ActivePlayerProvider
    extends $NotifierProvider<ActivePlayer, ActivePlayerController?> {
  const ActivePlayerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'activePlayerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$activePlayerHash();

  @$internal
  @override
  ActivePlayer create() => ActivePlayer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivePlayerController? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivePlayerController?>(value),
    );
  }
}

String _$activePlayerHash() => r'bc1d7d85f107214c0884c301c3fb107e25ea1afd';

abstract class _$ActivePlayer extends $Notifier<ActivePlayerController?> {
  ActivePlayerController? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<ActivePlayerController?, ActivePlayerController?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ActivePlayerController?, ActivePlayerController?>,
        ActivePlayerController?,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
