// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../display_screen_status.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DisplayScreenStatus)
const displayScreenStatusProvider = DisplayScreenStatusProvider._();

final class DisplayScreenStatusProvider
    extends $NotifierProvider<DisplayScreenStatus, DisplayScreenStatusModel> {
  const DisplayScreenStatusProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'displayScreenStatusProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$displayScreenStatusHash();

  @$internal
  @override
  DisplayScreenStatus create() => DisplayScreenStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DisplayScreenStatusModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DisplayScreenStatusModel>(value),
    );
  }
}

String _$displayScreenStatusHash() =>
    r'f6d2c1aae93102e04f2bd1483bcd7a1e6d892a57';

abstract class _$DisplayScreenStatus
    extends $Notifier<DisplayScreenStatusModel> {
  DisplayScreenStatusModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<DisplayScreenStatusModel, DisplayScreenStatusModel>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<DisplayScreenStatusModel, DisplayScreenStatusModel>,
        DisplayScreenStatusModel,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
