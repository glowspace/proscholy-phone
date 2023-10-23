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
    SongLyric songLyric,
  ) : this._internal(
          (ref) => autoScrollController(
            ref as AutoScrollControllerRef,
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
          songLyric: songLyric,
        );

  AutoScrollControllerProvider._internal(
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
  Override overrideWith(
    AutoScrollController Function(AutoScrollControllerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoScrollControllerProvider._internal(
        (ref) => create(ref as AutoScrollControllerRef),
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
  AutoDisposeProviderElement<AutoScrollController> createElement() {
    return _AutoScrollControllerProviderElement(this);
  }

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

mixin AutoScrollControllerRef on AutoDisposeProviderRef<AutoScrollController> {
  /// The parameter `songLyric` of this provider.
  SongLyric get songLyric;
}

class _AutoScrollControllerProviderElement
    extends AutoDisposeProviderElement<AutoScrollController>
    with AutoScrollControllerRef {
  _AutoScrollControllerProviderElement(super.provider);

  @override
  SongLyric get songLyric => (origin as AutoScrollControllerProvider).songLyric;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
