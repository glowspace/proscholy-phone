// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../songbooks.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PinnedSongbookIds)
const pinnedSongbookIdsProvider = PinnedSongbookIdsProvider._();

final class PinnedSongbookIdsProvider
    extends $NotifierProvider<PinnedSongbookIds, Set<int>> {
  const PinnedSongbookIdsProvider._()
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
    final created = build();
    final ref = this.ref as $Ref<Set<int>, Set<int>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Set<int>, Set<int>>, Set<int>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(songbooks)
const songbooksProvider = SongbooksProvider._();

final class SongbooksProvider
    extends $FunctionalProvider<List<Songbook>, List<Songbook>, List<Songbook>>
    with $Provider<List<Songbook>> {
  const SongbooksProvider._()
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

String _$songbooksHash() => r'8a11e795453ee27c44361043cb948d42b1a96179';
