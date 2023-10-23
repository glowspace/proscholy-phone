// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_text.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customTextHash() => r'b1ebfd1ed7d7787cdb0361ab58c73443392127f5';

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

/// See also [customText].
@ProviderFor(customText)
const customTextProvider = CustomTextFamily();

/// See also [customText].
class CustomTextFamily extends Family<CustomText?> {
  /// See also [customText].
  const CustomTextFamily();

  /// See also [customText].
  CustomTextProvider call(
    int id,
  ) {
    return CustomTextProvider(
      id,
    );
  }

  @override
  CustomTextProvider getProviderOverride(
    covariant CustomTextProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'customTextProvider';
}

/// See also [customText].
class CustomTextProvider extends AutoDisposeProvider<CustomText?> {
  /// See also [customText].
  CustomTextProvider(
    int id,
  ) : this._internal(
          (ref) => customText(
            ref as CustomTextRef,
            id,
          ),
          from: customTextProvider,
          name: r'customTextProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customTextHash,
          dependencies: CustomTextFamily._dependencies,
          allTransitiveDependencies:
              CustomTextFamily._allTransitiveDependencies,
          id: id,
        );

  CustomTextProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    CustomText? Function(CustomTextRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomTextProvider._internal(
        (ref) => create(ref as CustomTextRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<CustomText?> createElement() {
    return _CustomTextProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomTextProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CustomTextRef on AutoDisposeProviderRef<CustomText?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _CustomTextProviderElement extends AutoDisposeProviderElement<CustomText?>
    with CustomTextRef {
  _CustomTextProviderElement(super.provider);

  @override
  int get id => (origin as CustomTextProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
