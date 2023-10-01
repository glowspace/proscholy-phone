// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_scroll.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$autoScrollControllerHash() =>
    r'96253b51c311be625264f91c9e81ddcdee427299';

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

typedef AutoScrollControllerRef = AutoDisposeProviderRef<AutoScrollController>;

/// See also [autoScrollController].
@ProviderFor(autoScrollController)
const autoScrollControllerProvider = AutoScrollControllerFamily();

/// See also [autoScrollController].
class AutoScrollControllerFamily extends Family<AutoScrollController> {
  /// See also [autoScrollController].
  const AutoScrollControllerFamily();

  /// See also [autoScrollController].
  AutoScrollControllerProvider call(
    SongLyric songLyric,
  ) {
    return AutoScrollControllerProvider(
      songLyric,
    );
  }

  @override
  AutoScrollControllerProvider getProviderOverride(
    covariant AutoScrollControllerProvider provider,
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
  String? get name => r'autoScrollControllerProvider';
}

/// See also [autoScrollController].
class AutoScrollControllerProvider
    extends AutoDisposeProvider<AutoScrollController> {
  /// See also [autoScrollController].
  AutoScrollControllerProvider(
    this.songLyric,
  ) : super.internal(
          (ref) => autoScrollController(
            ref,
            songLyric,
          ),
          from: autoScrollControllerProvider,
          name: r'autoScrollControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$autoScrollControllerHash,
          dependencies: AutoScrollControllerFamily._dependencies,
          allTransitiveDependencies:
              AutoScrollControllerFamily._allTransitiveDependencies,
        );

  final SongLyric songLyric;

  @override
  bool operator ==(Object other) {
    return other is AutoScrollControllerProvider &&
        other.songLyric == songLyric;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, songLyric.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
