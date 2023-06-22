// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoritePlaylistHash() => r'86ce2b76733ebb9acf54507bc1c4870bacaeae8c';

/// See also [favoritePlaylist].
@ProviderFor(favoritePlaylist)
final favoritePlaylistProvider = AutoDisposeProvider<Playlist>.internal(
  favoritePlaylist,
  name: r'favoritePlaylistProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoritePlaylistHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FavoritePlaylistRef = AutoDisposeProviderRef<Playlist>;
String _$playlistsHash() => r'8e019809db7b81d5b9684923648fee54408403a8';

/// See also [Playlists].
@ProviderFor(Playlists)
final playlistsProvider =
    AutoDisposeNotifierProvider<Playlists, List<Playlist>>.internal(
  Playlists.new,
  name: r'playlistsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$playlistsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Playlists = AutoDisposeNotifier<List<Playlist>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
