// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(biblePassages)
final biblePassagesProvider = BiblePassagesFamily._();

final class BiblePassagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<dynamic>>,
          List<dynamic>,
          FutureOr<List<dynamic>>
        >
    with $FutureModifier<List<dynamic>>, $FutureProvider<List<dynamic>> {
  BiblePassagesProvider._({
    required BiblePassagesFamily super.from,
    required (BibleTranslation, BibleBook, int) super.argument,
  }) : super(
         retry: null,
         name: r'biblePassagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$biblePassagesHash();

  @override
  String toString() {
    return r'biblePassagesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<dynamic>> create(Ref ref) {
    final argument = this.argument as (BibleTranslation, BibleBook, int);
    return biblePassages(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is BiblePassagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$biblePassagesHash() => r'a9e5a4d7219995866b1306eee8b19a482b6a9a61';

final class BiblePassagesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<dynamic>>,
          (BibleTranslation, BibleBook, int)
        > {
  BiblePassagesFamily._()
    : super(
        retry: null,
        name: r'biblePassagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BiblePassagesProvider call(
    BibleTranslation translation,
    BibleBook book,
    int chapter,
  ) => BiblePassagesProvider._(
    argument: (translation, book, chapter),
    from: this,
  );

  @override
  String toString() => r'biblePassagesProvider';
}

@ProviderFor(biblePassage)
final biblePassageProvider = BiblePassageFamily._();

final class BiblePassageProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  BiblePassageProvider._({
    required BiblePassageFamily super.from,
    required (BibleTranslation, BibleBook, int, int, {int? endVerse})
    super.argument,
  }) : super(
         retry: null,
         name: r'biblePassageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$biblePassageHash();

  @override
  String toString() {
    return r'biblePassageProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument =
        this.argument
            as (BibleTranslation, BibleBook, int, int, {int? endVerse});
    return biblePassage(
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
    return other is BiblePassageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$biblePassageHash() => r'0235a873058580a38ed3a0ce8059e31f3c062e84';

final class BiblePassageFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<String>,
          (BibleTranslation, BibleBook, int, int, {int? endVerse})
        > {
  BiblePassageFamily._()
    : super(
        retry: null,
        name: r'biblePassageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BiblePassageProvider call(
    BibleTranslation translation,
    BibleBook book,
    int chapter,
    int startVerse, {
    int? endVerse,
  }) => BiblePassageProvider._(
    argument: (translation, book, chapter, startVerse, endVerse: endVerse),
    from: this,
  );

  @override
  String toString() => r'biblePassageProvider';
}
