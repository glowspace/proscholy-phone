// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../home.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeSectionSettings)
final homeSectionSettingsProvider = HomeSectionSettingsProvider._();

final class HomeSectionSettingsProvider
    extends $NotifierProvider<HomeSectionSettings, List<HomeSection>> {
  HomeSectionSettingsProvider._()
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
    r'08f3824f53c84c86c4f9575e8ae224abb08b224f';

abstract class _$HomeSectionSettings extends $Notifier<List<HomeSection>> {
  List<HomeSection> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<HomeSection>, List<HomeSection>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<HomeSection>, List<HomeSection>>,
              List<HomeSection>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
