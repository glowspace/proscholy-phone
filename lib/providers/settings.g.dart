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
String _$songLyricSettingsHash() => r'3f9de5eda5c5d9eef14066b8725c21a4ce6de3c2';

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
  late final SongLyric songLyric;

  SongLyricSettingsModel build(
    SongLyric songLyric,
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
    SongLyric songLyric,
  ) {
    return SongLyricSettingsProvider(
      songLyric,
    );
  }

  @override
  SongLyricSettingsProvider getProviderOverride(
    covariant SongLyricSettingsProvider provider,
  ) {
    return call(
      provider.songLyric,
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
    SongLyric songLyric,
  ) : this._internal(
          () => SongLyricSettings()..songLyric = songLyric,
          from: songLyricSettingsProvider,
          name: r'songLyricSettingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$songLyricSettingsHash,
          dependencies: SongLyricSettingsFamily._dependencies,
          allTransitiveDependencies:
              SongLyricSettingsFamily._allTransitiveDependencies,
          songLyric: songLyric,
        );

  SongLyricSettingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.songLyric,
  }) : super.internal();

  final SongLyric songLyric;

  @override
  SongLyricSettingsModel runNotifierBuild(
    covariant SongLyricSettings notifier,
  ) {
    return notifier.build(
      songLyric,
    );
  }

  @override
  Override overrideWith(SongLyricSettings Function() create) {
    return ProviderOverride(
      origin: this,
      override: SongLyricSettingsProvider._internal(
        () => create()..songLyric = songLyric,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        songLyric: songLyric,
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
    return other is SongLyricSettingsProvider && other.songLyric == songLyric;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, songLyric.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SongLyricSettingsRef
    on AutoDisposeNotifierProviderRef<SongLyricSettingsModel> {
  /// The parameter `songLyric` of this provider.
  SongLyric get songLyric;
}

class _SongLyricSettingsProviderElement
    extends AutoDisposeNotifierProviderElement<SongLyricSettings,
        SongLyricSettingsModel> with SongLyricSettingsRef {
  _SongLyricSettingsProviderElement(super.provider);

  @override
  SongLyric get songLyric => (origin as SongLyricSettingsProvider).songLyric;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
