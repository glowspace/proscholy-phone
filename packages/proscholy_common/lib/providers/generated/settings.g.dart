// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Settings)
const settingsProvider = SettingsProvider._();

final class SettingsProvider
    extends $NotifierProvider<Settings, GlobalSettings> {
  const SettingsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'settingsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$settingsHash();

  @$internal
  @override
  Settings create() => Settings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlobalSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GlobalSettings>(value),
    );
  }
}

String _$settingsHash() => r'7329639d7462d63ea8928d2fe12c68428e2f0bee';

abstract class _$Settings extends $Notifier<GlobalSettings> {
  GlobalSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GlobalSettings, GlobalSettings>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<GlobalSettings, GlobalSettings>,
        GlobalSettings,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SongLyricSettings)
const songLyricSettingsProvider = SongLyricSettingsFamily._();

final class SongLyricSettingsProvider
    extends $NotifierProvider<SongLyricSettings, SongLyricSettingsModel> {
  const SongLyricSettingsProvider._(
      {required SongLyricSettingsFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'songLyricSettingsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$songLyricSettingsHash();

  @override
  String toString() {
    return r'songLyricSettingsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SongLyricSettings create() => SongLyricSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SongLyricSettingsModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SongLyricSettingsModel>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SongLyricSettingsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$songLyricSettingsHash() => r'0ad88059920a88656e392a95d62829c72dc878b8';

final class SongLyricSettingsFamily extends $Family
    with
        $ClassFamilyOverride<SongLyricSettings, SongLyricSettingsModel,
            SongLyricSettingsModel, SongLyricSettingsModel, int> {
  const SongLyricSettingsFamily._()
      : super(
          retry: null,
          name: r'songLyricSettingsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SongLyricSettingsProvider call(
    int songLyricId,
  ) =>
      SongLyricSettingsProvider._(argument: songLyricId, from: this);

  @override
  String toString() => r'songLyricSettingsProvider';
}

abstract class _$SongLyricSettings extends $Notifier<SongLyricSettingsModel> {
  late final _$args = ref.$arg as int;
  int get songLyricId => _$args;

  SongLyricSettingsModel build(
    int songLyricId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref =
        this.ref as $Ref<SongLyricSettingsModel, SongLyricSettingsModel>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SongLyricSettingsModel, SongLyricSettingsModel>,
        SongLyricSettingsModel,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
