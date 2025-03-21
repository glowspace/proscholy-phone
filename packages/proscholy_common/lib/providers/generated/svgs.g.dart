// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../svgs.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$svgsHash() => r'1b27a273e3d071a402ff874f8865ce7637c011ec';

/// See also [Svgs].
@ProviderFor(Svgs)
final svgsProvider =
    NotifierProvider<Svgs, Map<String, FileSystemEntity>>.internal(
  Svgs.new,
  name: r'svgsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$svgsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Svgs = Notifier<Map<String, FileSystemEntity>>;
String _$svgHash() => r'b914e952dee78cce383080765a1ea85b6ab0694f';

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

abstract class _$Svg extends BuildlessAutoDisposeNotifier<String> {
  late final int songLyricId;

  String build(
    int songLyricId,
  );
}

/// See also [Svg].
@ProviderFor(Svg)
const svgProvider = SvgFamily();

/// See also [Svg].
class SvgFamily extends Family<String> {
  /// See also [Svg].
  const SvgFamily();

  /// See also [Svg].
  SvgProvider call(
    int songLyricId,
  ) {
    return SvgProvider(
      songLyricId,
    );
  }

  @override
  SvgProvider getProviderOverride(
    covariant SvgProvider provider,
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
  String? get name => r'svgProvider';
}

/// See also [Svg].
class SvgProvider extends AutoDisposeNotifierProviderImpl<Svg, String> {
  /// See also [Svg].
  SvgProvider(
    int songLyricId,
  ) : this._internal(
          () => Svg()..songLyricId = songLyricId,
          from: svgProvider,
          name: r'svgProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$svgHash,
          dependencies: SvgFamily._dependencies,
          allTransitiveDependencies: SvgFamily._allTransitiveDependencies,
          songLyricId: songLyricId,
        );

  SvgProvider._internal(
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
  String runNotifierBuild(
    covariant Svg notifier,
  ) {
    return notifier.build(
      songLyricId,
    );
  }

  @override
  Override overrideWith(Svg Function() create) {
    return ProviderOverride(
      origin: this,
      override: SvgProvider._internal(
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
  AutoDisposeNotifierProviderElement<Svg, String> createElement() {
    return _SvgProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SvgProvider && other.songLyricId == songLyricId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, songLyricId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SvgRef on AutoDisposeNotifierProviderRef<String> {
  /// The parameter `songLyricId` of this provider.
  int get songLyricId;
}

class _SvgProviderElement
    extends AutoDisposeNotifierProviderElement<Svg, String> with SvgRef {
  _SvgProviderElement(super.provider);

  @override
  int get songLyricId => (origin as SvgProvider).songLyricId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
