// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../bible_passage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(biblePassage)
final biblePassageProvider = BiblePassageFamily._();

final class BiblePassageProvider
    extends $FunctionalProvider<BiblePassage?, BiblePassage?, BiblePassage?>
    with $Provider<BiblePassage?> {
  BiblePassageProvider._({
    required BiblePassageFamily super.from,
    required int super.argument,
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
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<BiblePassage?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BiblePassage? create(Ref ref) {
    final argument = this.argument as int;
    return biblePassage(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BiblePassage? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BiblePassage?>(value),
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

String _$biblePassageHash() => r'a33cd1cf815a7e1c12c0d4f4fdf299eef34751e5';

final class BiblePassageFamily extends $Family
    with $FunctionalFamilyOverride<BiblePassage?, int> {
  BiblePassageFamily._()
    : super(
        retry: null,
        name: r'biblePassageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BiblePassageProvider call(int id) =>
      BiblePassageProvider._(argument: id, from: this);

  @override
  String toString() => r'biblePassageProvider';
}
