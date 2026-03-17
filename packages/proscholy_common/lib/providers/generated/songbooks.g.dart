// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../songbooks.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(songbook)
final songbookProvider = SongbookFamily._();

final class SongbookProvider
    extends $FunctionalProvider<Songbook?, Songbook?, Songbook?>
    with $Provider<Songbook?> {
  SongbookProvider._(
      {required SongbookFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'songbookProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$songbookHash();

  @override
  String toString() {
    return r'songbookProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Songbook?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Songbook? create(Ref ref) {
    final argument = this.argument as int;
    return songbook(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Songbook? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Songbook?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SongbookProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$songbookHash() => r'2856322be94db22ad46965b2371a2578999681db';

final class SongbookFamily extends $Family
    with $FunctionalFamilyOverride<Songbook?, int> {
  SongbookFamily._()
      : super(
          retry: null,
          name: r'songbookProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SongbookProvider call(
    int id,
  ) =>
      SongbookProvider._(argument: id, from: this);

  @override
  String toString() => r'songbookProvider';
}

@ProviderFor(PinnedSongbookIds)
final pinnedSongbookIdsProvider = PinnedSongbookIdsProvider._();

final class PinnedSongbookIdsProvider
    extends $NotifierProvider<PinnedSongbookIds, Set<int>> {
  PinnedSongbookIdsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'pinnedSongbookIdsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$pinnedSongbookIdsHash();

  @$internal
  @override
  PinnedSongbookIds create() => PinnedSongbookIds();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<int>>(value),
    );
  }
}

String _$pinnedSongbookIdsHash() => r'b8ee2a8e41bd78a107041c0ce2e84b8464b424a4';

abstract class _$PinnedSongbookIds extends $Notifier<Set<int>> {
  Set<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<int>, Set<int>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Set<int>, Set<int>>, Set<int>, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(songbooks)
final songbooksProvider = SongbooksProvider._();

final class SongbooksProvider
    extends $FunctionalProvider<List<Songbook>, List<Songbook>, List<Songbook>>
    with $Provider<List<Songbook>> {
  SongbooksProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'songbooksProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$songbooksHash();

  @$internal
  @override
  $ProviderElement<List<Songbook>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Songbook> create(Ref ref) {
    return songbooks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Songbook> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Songbook>>(value),
    );
  }
}

String _$songbooksHash() => r'aaf429070c9f2b43ff7b2aacd3833705b186eb40';
