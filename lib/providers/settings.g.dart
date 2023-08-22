// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsHash() => r'868427961afc4de9047b57b47abc26f255a5b172';

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
String _$songLyricSettingsHash() => r'2807ebce5ee05511309f83bb4be7cf66d3ac6749';

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
    this.songLyric,
  ) : super.internal(
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
        );

  final SongLyric songLyric;

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

  @override
  SongLyricSettingsModel runNotifierBuild(
    covariant SongLyricSettings notifier,
  ) {
    return notifier.build(
      songLyric,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
