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

typedef BibleVersesRef = FutureProviderRef<List<dynamic>>;

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
    this.translation,
    this.book,
    this.chapter,
  ) : super.internal(
          (ref) => bibleVerses(
            ref,
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
        );

  final BibleTranslation translation;
  final BibleBook book;
  final int chapter;

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

String _$bibleVerseHash() => r'53a6aef920214c2266f162c27e36a407a3707c2c';
typedef BibleVerseRef = AutoDisposeFutureProviderRef<String>;

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
    this.translation,
    this.book,
    this.chapter,
    this.startVerse, {
    this.endVerse,
  }) : super.internal(
          (ref) => bibleVerse(
            ref,
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
        );

  final BibleTranslation translation;
  final BibleBook book;
  final int chapter;
  final int startVerse;
  final int? endVerse;

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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
