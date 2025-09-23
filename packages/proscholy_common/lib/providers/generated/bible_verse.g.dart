// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../bible_verse.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bibleVerse)
const bibleVerseProvider = BibleVerseFamily._();

final class BibleVerseProvider
    extends $FunctionalProvider<BibleVerse?, BibleVerse?, BibleVerse?>
    with $Provider<BibleVerse?> {
  const BibleVerseProvider._(
      {required BibleVerseFamily super.from, required int super.argument})
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
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<BibleVerse?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BibleVerse? create(Ref ref) {
    final argument = this.argument as int;
    return bibleVerse(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BibleVerse? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BibleVerse?>(value),
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

String _$bibleVerseHash() => r'd4e6136f55d09731ce14ca63679f131a13c438ec';

final class BibleVerseFamily extends $Family
    with $FunctionalFamilyOverride<BibleVerse?, int> {
  const BibleVerseFamily._()
      : super(
          retry: null,
          name: r'bibleVerseProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  BibleVerseProvider call(
    int id,
  ) =>
      BibleVerseProvider._(argument: id, from: this);

  @override
  String toString() => r'bibleVerseProvider';
}
