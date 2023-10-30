// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsHash() => r'4fa2b2e521941ad6a21d80f26fb76589cf8001a8';

/// See also [Settings].
@ProviderFor(Settings)
final settingsProvider =
    AutoDisposeNotifierProvider<Settings, GlobalSettings>.internal(
  Settings.new,
  name: r'settingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$settingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Settings = AutoDisposeNotifier<GlobalSettings>;
String _$songLyricSettingsHash() => r'28d7969de835bac405764a0808a995ee1c894b40';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$SongLyricSettings
    extends BuildlessAutoDisposeNotifier<SongLyricSettingsModel> {
  late final int songLyricId;

  SongLyricSettingsModel build(
    int songLyricId,
  );
}

/// See also [SongLyricSettings].
@ProviderFor(SongLyricSettings)
const songLyricSettingsProvider = SongLyricSettingsFamily();

/// See also [SongLyricSettings].
class SongLyricSettingsFamily extends Family<SongLyricSettingsModel> {
  /// See also [SongLyricSettings].
  const SongLyricSettingsFamily();

  /// See also [SongLyricSettings].
  SongLyricSettingsProvider call(
    int songLyricId,
  ) {
    return SongLyricSettingsProvider(
      songLyricId,
    );
  }

  @override
  SongLyricSettingsProvider getProviderOverride(
    covariant SongLyricSettingsProvider provider,
  ) {
    return call(
      provider.songLyricId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'songLyricSettingsProvider';
}

/// See also [SongLyricSettings].
class SongLyricSettingsProvider extends AutoDisposeNotifierProviderImpl<
    SongLyricSettings, SongLyricSettingsModel> {
  /// See also [SongLyricSettings].
  SongLyricSettingsProvider(
    int songLyricId,
  ) : this._internal(
          () => SongLyricSettings()..songLyricId = songLyricId,
          from: songLyricSettingsProvider,
          name: r'songLyricSettingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$songLyricSettingsHash,
          dependencies: SongLyricSettingsFamily._dependencies,
          allTransitiveDependencies:
              SongLyricSettingsFamily._allTransitiveDependencies,
          songLyricId: songLyricId,
        );

  SongLyricSettingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.songLyricId,
  }) : super.internal();

  final int songLyricId;

  @override
  SongLyricSettingsModel runNotifierBuild(
    covariant SongLyricSettings notifier,
  ) {
    return notifier.build(
      songLyricId,
    );
  }

  @override
  Override overrideWith(SongLyricSettings Function() create) {
    return ProviderOverride(
      origin: this,
      override: SongLyricSettingsProvider._internal(
        () => create()..songLyricId = songLyricId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        songLyricId: songLyricId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SongLyricSettings, SongLyricSettingsModel>
      createElement() {
    return _SongLyricSettingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SongLyricSettingsProvider &&
        other.songLyricId == songLyricId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, songLyricId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SongLyricSettingsRef
    on AutoDisposeNotifierProviderRef<SongLyricSettingsModel> {
  /// The parameter `songLyricId` of this provider.
  int get songLyricId;
}

class _SongLyricSettingsProviderElement
    extends AutoDisposeNotifierProviderElement<SongLyricSettings,
        SongLyricSettingsModel> with SongLyricSettingsRef {
  _SongLyricSettingsProviderElement(super.provider);

  @override
  int get songLyricId => (origin as SongLyricSettingsProvider).songLyricId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
