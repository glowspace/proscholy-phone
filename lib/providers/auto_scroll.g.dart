// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_scroll.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$autoScrollControllerHash() =>
    r'918236e992bdc4eef068c6a820c9e16987784524';

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
    DisplayableItem displayableItem,
  ) {
    return AutoScrollControllerProvider(
      displayableItem,
    );
  }

  @override
  AutoScrollControllerProvider getProviderOverride(
    covariant AutoScrollControllerProvider provider,
  ) {
    return call(
      provider.displayableItem,
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
    DisplayableItem displayableItem,
  ) : this._internal(
          (ref) => autoScrollController(
            ref as AutoScrollControllerRef,
            displayableItem,
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
          displayableItem: displayableItem,
        );

  AutoScrollControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.displayableItem,
  }) : super.internal();

  final DisplayableItem displayableItem;

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
        displayableItem: displayableItem,
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
        other.displayableItem == displayableItem;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, displayableItem.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AutoScrollControllerRef on AutoDisposeProviderRef<AutoScrollController> {
  /// The parameter `displayableItem` of this provider.
  DisplayableItem get displayableItem;
}

class _AutoScrollControllerProviderElement
    extends AutoDisposeProviderElement<AutoScrollController>
    with AutoScrollControllerRef {
  _AutoScrollControllerProviderElement(super.provider);

  @override
  DisplayableItem get displayableItem =>
      (origin as AutoScrollControllerProvider).displayableItem;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
