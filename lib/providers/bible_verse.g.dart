// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_verse.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bibleVerseHash() => r'b9fe236c5ddcea301d4aa8d517ecd7459dceb690';

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

/// See also [bibleVerse].
@ProviderFor(bibleVerse)
const bibleVerseProvider = BibleVerseFamily();

/// See also [bibleVerse].
class BibleVerseFamily extends Family<BibleVerse?> {
  /// See also [bibleVerse].
  const BibleVerseFamily();

  /// See also [bibleVerse].
  BibleVerseProvider call(
    int id,
  ) {
    return BibleVerseProvider(
      id,
    );
  }

  @override
  BibleVerseProvider getProviderOverride(
    covariant BibleVerseProvider provider,
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
  String? get name => r'bibleVerseProvider';
}

/// See also [bibleVerse].
class BibleVerseProvider extends AutoDisposeProvider<BibleVerse?> {
  /// See also [bibleVerse].
  BibleVerseProvider(
    int id,
  ) : this._internal(
          (ref) => bibleVerse(
            ref as BibleVerseRef,
            id,
          ),
          from: bibleVerseProvider,
          name: r'bibleVerseProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bibleVerseHash,
          dependencies: BibleVerseFamily._dependencies,
          allTransitiveDependencies:
              BibleVerseFamily._allTransitiveDependencies,
          id: id,
        );

  BibleVerseProvider._internal(
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
    BibleVerse? Function(BibleVerseRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BibleVerseProvider._internal(
        (ref) => create(ref as BibleVerseRef),
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
  AutoDisposeProviderElement<BibleVerse?> createElement() {
    return _BibleVerseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BibleVerseProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BibleVerseRef on AutoDisposeProviderRef<BibleVerse?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _BibleVerseProviderElement extends AutoDisposeProviderElement<BibleVerse?>
    with BibleVerseRef {
  _BibleVerseProviderElement(super.provider);

  @override
  int get id => (origin as BibleVerseProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
