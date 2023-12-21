// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bibleVersesHash() => r'63f5585fc72afcdc48b4d84fe314164a6d3fdbdd';

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

/// See also [bibleVerses].
@ProviderFor(bibleVerses)
const bibleVersesProvider = BibleVersesFamily();

/// See also [bibleVerses].
class BibleVersesFamily extends Family<AsyncValue<List<dynamic>>> {
  /// See also [bibleVerses].
  const BibleVersesFamily();

  /// See also [bibleVerses].
  BibleVersesProvider call(
    BibleTranslation translation,
    BibleBook book,
    int chapter,
  ) {
    return BibleVersesProvider(
      translation,
      book,
      chapter,
    );
  }

  @override
  BibleVersesProvider getProviderOverride(
    covariant BibleVersesProvider provider,
  ) {
    return call(
      provider.translation,
      provider.book,
      provider.chapter,
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
  String? get name => r'bibleVersesProvider';
}

/// See also [bibleVerses].
class BibleVersesProvider extends FutureProvider<List<dynamic>> {
  /// See also [bibleVerses].
  BibleVersesProvider(
    BibleTranslation translation,
    BibleBook book,
    int chapter,
  ) : this._internal(
          (ref) => bibleVerses(
            ref as BibleVersesRef,
            translation,
            book,
            chapter,
          ),
          from: bibleVersesProvider,
          name: r'bibleVersesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bibleVersesHash,
          dependencies: BibleVersesFamily._dependencies,
          allTransitiveDependencies:
              BibleVersesFamily._allTransitiveDependencies,
          translation: translation,
          book: book,
          chapter: chapter,
        );

  BibleVersesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.translation,
    required this.book,
    required this.chapter,
  }) : super.internal();

  final BibleTranslation translation;
  final BibleBook book;
  final int chapter;

  @override
  Override overrideWith(
    FutureOr<List<dynamic>> Function(BibleVersesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BibleVersesProvider._internal(
        (ref) => create(ref as BibleVersesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        translation: translation,
        book: book,
        chapter: chapter,
      ),
    );
  }

  @override
  FutureProviderElement<List<dynamic>> createElement() {
    return _BibleVersesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BibleVersesProvider &&
        other.translation == translation &&
        other.book == book &&
        other.chapter == chapter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, translation.hashCode);
    hash = _SystemHash.combine(hash, book.hashCode);
    hash = _SystemHash.combine(hash, chapter.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BibleVersesRef on FutureProviderRef<List<dynamic>> {
  /// The parameter `translation` of this provider.
  BibleTranslation get translation;

  /// The parameter `book` of this provider.
  BibleBook get book;

  /// The parameter `chapter` of this provider.
  int get chapter;
}

class _BibleVersesProviderElement extends FutureProviderElement<List<dynamic>>
    with BibleVersesRef {
  _BibleVersesProviderElement(super.provider);

  @override
  BibleTranslation get translation =>
      (origin as BibleVersesProvider).translation;
  @override
  BibleBook get book => (origin as BibleVersesProvider).book;
  @override
  int get chapter => (origin as BibleVersesProvider).chapter;
}

String _$bibleVerseHash() => r'b01943f2c24dadf7125d7d6a5654fbd89e0966c0';

/// See also [bibleVerse].
@ProviderFor(bibleVerse)
const bibleVerseProvider = BibleVerseFamily();

/// See also [bibleVerse].
class BibleVerseFamily extends Family<AsyncValue<String>> {
  /// See also [bibleVerse].
  const BibleVerseFamily();

  /// See also [bibleVerse].
  BibleVerseProvider call(
    BibleTranslation translation,
    BibleBook book,
    int chapter,
    int startVerse, {
    int? endVerse,
  }) {
    return BibleVerseProvider(
      translation,
      book,
      chapter,
      startVerse,
      endVerse: endVerse,
    );
  }

  @override
  BibleVerseProvider getProviderOverride(
    covariant BibleVerseProvider provider,
  ) {
    return call(
      provider.translation,
      provider.book,
      provider.chapter,
      provider.startVerse,
      endVerse: provider.endVerse,
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
class BibleVerseProvider extends AutoDisposeFutureProvider<String> {
  /// See also [bibleVerse].
  BibleVerseProvider(
    BibleTranslation translation,
    BibleBook book,
    int chapter,
    int startVerse, {
    int? endVerse,
  }) : this._internal(
          (ref) => bibleVerse(
            ref as BibleVerseRef,
            translation,
            book,
            chapter,
            startVerse,
            endVerse: endVerse,
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
          translation: translation,
          book: book,
          chapter: chapter,
          startVerse: startVerse,
          endVerse: endVerse,
        );

  BibleVerseProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.translation,
    required this.book,
    required this.chapter,
    required this.startVerse,
    required this.endVerse,
  }) : super.internal();

  final BibleTranslation translation;
  final BibleBook book;
  final int chapter;
  final int startVerse;
  final int? endVerse;

  @override
  Override overrideWith(
    FutureOr<String> Function(BibleVerseRef provider) create,
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
        translation: translation,
        book: book,
        chapter: chapter,
        startVerse: startVerse,
        endVerse: endVerse,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _BibleVerseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BibleVerseProvider &&
        other.translation == translation &&
        other.book == book &&
        other.chapter == chapter &&
        other.startVerse == startVerse &&
        other.endVerse == endVerse;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, translation.hashCode);
    hash = _SystemHash.combine(hash, book.hashCode);
    hash = _SystemHash.combine(hash, chapter.hashCode);
    hash = _SystemHash.combine(hash, startVerse.hashCode);
    hash = _SystemHash.combine(hash, endVerse.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BibleVerseRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `translation` of this provider.
  BibleTranslation get translation;

  /// The parameter `book` of this provider.
  BibleBook get book;

  /// The parameter `chapter` of this provider.
  int get chapter;

  /// The parameter `startVerse` of this provider.
  int get startVerse;

  /// The parameter `endVerse` of this provider.
  int? get endVerse;
}

class _BibleVerseProviderElement
    extends AutoDisposeFutureProviderElement<String> with BibleVerseRef {
  _BibleVerseProviderElement(super.provider);

  @override
  BibleTranslation get translation =>
      (origin as BibleVerseProvider).translation;
  @override
  BibleBook get book => (origin as BibleVerseProvider).book;
  @override
  int get chapter => (origin as BibleVerseProvider).chapter;
  @override
  int get startVerse => (origin as BibleVerseProvider).startVerse;
  @override
  int? get endVerse => (origin as BibleVerseProvider).endVerse;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
