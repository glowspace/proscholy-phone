// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songbooks.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$songbooksHash() => r'd2c2bc7eda7e913910efebc6b04202689e89ca52';

/// See also [songbooks].
@ProviderFor(songbooks)
final songbooksProvider = Provider<List<Songbook>>.internal(
  songbooks,
  name: r'songbooksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$songbooksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SongbooksRef = ProviderRef<List<Songbook>>;
String _$pinnedSongbookIdsHash() => r'858f80cf4690384887c3d87e57ef72c75e975a5e';

/// See also [PinnedSongbookIds].
@ProviderFor(PinnedSongbookIds)
final pinnedSongbookIdsProvider =
    NotifierProvider<PinnedSongbookIds, Set<int>>.internal(
  PinnedSongbookIds.new,
  name: r'pinnedSongbookIdsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pinnedSongbookIdsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PinnedSongbookIds = Notifier<Set<int>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
