// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoritePlaylistHash() => r'e489a6e7488d1c65771aecfaaf731228a14c4608';

/// See also [favoritePlaylist].
@ProviderFor(favoritePlaylist)
final favoritePlaylistProvider = Provider<Playlist>.internal(
  favoritePlaylist,
  name: r'favoritePlaylistProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoritePlaylistHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FavoritePlaylistRef = ProviderRef<Playlist>;
String _$playlistsHash() => r'f168306dca48c413283dc75fc10302b9219375d4';

/// See also [Playlists].
@ProviderFor(Playlists)
final playlistsProvider = NotifierProvider<Playlists, List<Playlist>>.internal(
  Playlists.new,
  name: r'playlistsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$playlistsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Playlists = Notifier<List<Playlist>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
