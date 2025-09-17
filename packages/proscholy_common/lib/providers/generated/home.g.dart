// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../home.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeSectionSettings)
const homeSectionSettingsProvider = HomeSectionSettingsProvider._();

final class HomeSectionSettingsProvider
    extends $NotifierProvider<HomeSectionSettings, List<HomeSection>> {
  const HomeSectionSettingsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'homeSectionSettingsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$homeSectionSettingsHash();

  @$internal
  @override
  HomeSectionSettings create() => HomeSectionSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<HomeSection> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<HomeSection>>(value),
    );
  }
}

String _$homeSectionSettingsHash() =>
    r'366d1e46aea16cb0ce96dec4a2e6916e5e6aabbd';

abstract class _$HomeSectionSettings extends $Notifier<List<HomeSection>> {
  List<HomeSection> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<HomeSection>, List<HomeSection>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<HomeSection>, List<HomeSection>>,
        List<HomeSection>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
