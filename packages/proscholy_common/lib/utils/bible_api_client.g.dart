// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bibleVerses)
const bibleVersesProvider = BibleVersesFamily._();

final class BibleVersesProvider extends $FunctionalProvider<
        AsyncValue<List<dynamic>>, List<dynamic>, FutureOr<List<dynamic>>>
    with $FutureModifier<List<dynamic>>, $FutureProvider<List<dynamic>> {
  const BibleVersesProvider._(
      {required BibleVersesFamily super.from,
      required (
        BibleTranslation,
        BibleBook,
        int,
      )
          super.argument})
      : super(
          retry: null,
          name: r'bibleVersesProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$bibleVersesHash();

  @override
  String toString() {
    return r'bibleVersesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<dynamic>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<dynamic>> create(Ref ref) {
    final argument = this.argument as (
      BibleTranslation,
      BibleBook,
      int,
    );
    return bibleVerses(
      ref,
      argument.$1,
      argument.$2,
      argument.$3,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BibleVersesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bibleVersesHash() => r'acd28f6fea75821a7a96bb15a33449b003e337a0';

final class BibleVersesFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<dynamic>>,
            (
              BibleTranslation,
              BibleBook,
              int,
            )> {
  const BibleVersesFamily._()
      : super(
          retry: null,
          name: r'bibleVersesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: false,
        );

  BibleVersesProvider call(
    BibleTranslation translation,
    BibleBook book,
    int chapter,
  ) =>
      BibleVersesProvider._(argument: (
        translation,
        book,
        chapter,
      ), from: this);

  @override
  String toString() => r'bibleVersesProvider';
}

@ProviderFor(bibleVerse)
const bibleVerseProvider = BibleVerseFamily._();

final class BibleVerseProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  const BibleVerseProvider._(
      {required BibleVerseFamily super.from,
      required (
        BibleTranslation,
        BibleBook,
        int,
        int, {
        int? endVerse,
      })
          super.argument})
      : super(
          retry: null,
          name: r'bibleVerseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$bibleVerseHash();

  @override
  String toString() {
    return r'bibleVerseProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as (
      BibleTranslation,
      BibleBook,
      int,
      int, {
      int? endVerse,
    });
    return bibleVerse(
      ref,
      argument.$1,
      argument.$2,
      argument.$3,
      argument.$4,
      endVerse: argument.endVerse,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BibleVerseProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bibleVerseHash() => r'd5dd1b90dc108f12058fa99c5bb5ea4c86592ec4';

final class BibleVerseFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<String>,
            (
              BibleTranslation,
              BibleBook,
              int,
              int, {
              int? endVerse,
            })> {
  const BibleVerseFamily._()
      : super(
          retry: null,
          name: r'bibleVerseProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  BibleVerseProvider call(
    BibleTranslation translation,
    BibleBook book,
    int chapter,
    int startVerse, {
    int? endVerse,
  }) =>
      BibleVerseProvider._(argument: (
        translation,
        book,
        chapter,
        startVerse,
        endVerse: endVerse,
      ), from: this);

  @override
  String toString() => r'bibleVerseProvider';
}
