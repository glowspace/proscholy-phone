// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songbooks.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$songbooksHash() => r'8a11e795453ee27c44361043cb948d42b1a96179';

/// See also [songbooks].
@ProviderFor(songbooks)
final songbooksProvider = AutoDisposeProvider<List<Songbook>>.internal(
  songbooks,
  name: r'songbooksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$songbooksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SongbooksRef = AutoDisposeProviderRef<List<Songbook>>;
String _$pinnedSongbookIdsHash() => r'1a656d296c8a7ce7da95f6957b69496149d9ce20';

/// See also [PinnedSongbookIds].
@ProviderFor(PinnedSongbookIds)
final pinnedSongbookIdsProvider =
    AutoDisposeNotifierProvider<PinnedSongbookIds, Set<int>>.internal(
  PinnedSongbookIds.new,
  name: r'pinnedSongbookIdsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pinnedSongbookIdsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PinnedSongbookIds = AutoDisposeNotifier<Set<int>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
